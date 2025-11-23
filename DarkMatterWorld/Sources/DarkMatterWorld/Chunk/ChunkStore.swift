//
//  ChunkStore.swift
//  DarkMatterWorld
//
//  Created by Sergey on 16.11.2025.
//

import Foundation

final class ChunkStore {
    private let typeMap: ComponentTypeMap
    private let orderMap: ComponentOrderMap
    private let chunkSize: Int
    private var entities: GenerationalArray<EntityLocation> = .init()
    private var chunks: [Chunk] = []
    
    // Index map for fast-search corresponding archetype
    private var chunkIndexMap: [CanonizedComponentIdentifiers: [Int]] = [:]

    init(
        components: [Component.Type],
        chunkSize: Int,
    ) {
        self.typeMap = .with(components)
        self.orderMap = .with(components) { $0.componentId }
        self.chunkSize = chunkSize
    }
    
    func isAlive(_ entityId: EntityId) -> Bool {
        entities[entityId.id] != nil
    }
    
    func get<T: Component>(_ entityId: EntityId, type: T.Type) -> T? {
        guard let location = entities[entityId.id] else {
            return nil
        }
        return chunks[location.chunkIndex]
            .get(at: location.index, type)
    }
    
    func set<T: Component>(_ entityId: EntityId, value: T) -> Bool {
        guard let location = entities[entityId.id] else {
            return false
        }
        return chunks[location.chunkIndex]
            .set(at: location.index, value)
    }
    
    func addComponent<T: Component>(_ entityId: EntityId, _ value: T) throws {
        var components = try getAllComponents(entityId)
        components.append(value)
        try alter(entityId, with: components)
    }
    
    func removeComponent<T: Component>(_ entityId: EntityId, _ type: T.Type) throws {
        let components = try getAllComponents(entityId)
            .filter { $0.componentId != T.componentId }
        try alter(entityId, with: components)
    }
        
    func remove(_ entityId: EntityId) throws {
        let stableIndex = entityId.id
        guard let location = entities.get(at: stableIndex) else {
            throw DarkMatterError.entityNotFound(entityId)
        }
        entities.remove(at: stableIndex)
        // update location for affected entity
        let affectedEntityId = chunks[location.chunkIndex]
            .remove(at: location.index)
        let isOk = entities.set(
            at: affectedEntityId.id,
            newValue: location
        )
        assert(isOk, "Failed to update entity \(entityId) with location \(location). May appear due race condition")
    }
    
    func append(_ components: [Component]) throws -> EntityId {
        try write(components) {
            // reserve the slot for a new entity
            let stableIndex = entities.append(.invalid)
            return EntityId(id: stableIndex)
        }
    }
        
    @discardableResult
    private func write(
        _ components: [Component],
        destinationEntityId: () -> EntityId
    ) throws -> EntityId {
        // ensure that we can add an new entity to some chunk
        let canonizedComponents = try components.canonize(orderMap)
        let canonizedIds = canonizedComponents.canonizedIdentifiers()
        let chunkIndex = try findFreeChunk(canonizedIds) ?? pushNewChunk(canonizedIds)
        
        let entityId = destinationEntityId()
        
        let index = try chunks[chunkIndex]
            .uncheckedAppend(entityId, canonizedComponents)
        let location = EntityLocation(
            chunkIndex: chunkIndex,
            index: index
        )
        // write final location for specified entityId
        let isOk = entities.set(at: entityId.id, newValue: location)
        assert(isOk, "Failed to update entity \(entityId) with location \(location). May appear due race condition")
        return entityId
    }
    
    private func pushNewChunk(
        _ canonizedIds: CanonizedComponentIdentifiers
    ) throws -> Int {
        let index = chunks.count
        let chunk = try Chunk(
            identifiers: canonizedIds,
            count: chunkSize,
            typeMap: typeMap
        )
        chunks.append(chunk)
        
        var indices = chunkIndexMap[canonizedIds] ?? []
        indices.append(index)
        chunkIndexMap[canonizedIds] = indices
        
        return index
    }
    
    private func findFreeChunk(
        _ identifiers: CanonizedComponentIdentifiers
    ) -> Int? {
        guard let indices = chunkIndexMap[identifiers] else {
            return nil
        }        
        for index in indices {
            if chunks[index].hasFreeSlots {
                return index
            }
        }
        return nil
    }
    
    private func getAllComponents(_ entityId: EntityId) throws -> [Component] {
        guard let location = entities[entityId.id] else {
            throw DarkMatterError.entityNotFound(entityId)
        }
        return chunks[location.chunkIndex]
            .getAllComponents(at: location.index)
    }
    
    private func alter(
        _ entityId: EntityId,
        with components: [any Component]
    ) throws {
        let stableIndex = entityId.id
        guard let location = entities.get(at: stableIndex) else {
            throw DarkMatterError.entityNotFound(entityId)
        }
        chunks[location.chunkIndex].remove(at: location.index)
        try write(components) { entityId }
    }
}

struct EntityLocation: Hashable {
    let chunkIndex: Int
    let index: Int
    
    static let invalid = Self(
        chunkIndex: -1,
        index: -1
    )
}

#if DEBUG
extension ChunkStore {
    var _entitiesCount: Int { entities.count }
    var _chunksCount: Int { chunks.count }
    var _typeMapCount: Int { typeMap.count }
    var _orderMapCount: Int { orderMap.count }
    var _chunkSize: Int { chunkSize }
    var _archetypesCount: Int { chunkIndexMap.count }
}
#endif
