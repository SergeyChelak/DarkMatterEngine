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
        self.orderMap = .with(components)
        self.chunkSize = chunkSize
    }
    
    func get<T: Component>(_ entityId: EntityId, type: T.Type) -> T? {
        fatalError()
    }
    
    func set<T: Component>(_ entityId: EntityId, value: T) -> Bool {
        fatalError()
    }
    
    func addComponent<T: Component>(_ entityId: EntityId, _ value: T) throws {
        var components = getAllComponents(entityId)
        components.append(value)
        try alter(entityId, with: components)
    }
    
    func removeComponent<T: Component>(_ entityId: EntityId, _ type: T.Type) throws {
        let components = getAllComponents(entityId)
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
        let chunk = try allocateChunk(for: canonizedIds, count: chunkSize)
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
    
    private func allocateChunk(
        for identifiers: CanonizedComponentIdentifiers,
        count: Int
    ) throws -> Chunk {
        let data = try identifiers
            .map {
                guard let type = typeMap[$0] else {
                    throw DarkMatterError.unknownComponent($0)
                }
                return AnyComponentDenseArray(
                    for: type,
                    capacity: count
                )
            }
        return Chunk(
            identifiers: identifiers,
            data: data,
            size: count
        )
    }
    
    private func getAllComponents(_ entityId: EntityId) -> [Component] {
        fatalError()
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

fileprivate typealias ComponentTypeMap = [ComponentIdentifier: Component.Type]

fileprivate extension ComponentTypeMap {
    static func with(_ components: [Component.Type]) -> Self {
        var map = Self()
        for component in components {
            let id = component.componentId
            map[id] = component
        }
        return map
    }
}

typealias ComponentOrderMap = [ComponentIdentifier: Int]

fileprivate extension ComponentOrderMap {
    static func with(_ components: [Component.Type]) -> Self {
        var orderMap = Self()
        for (index, component) in components.enumerated() {
            let id = component.componentId
            orderMap[id] = index
        }
        return orderMap
    }
}
