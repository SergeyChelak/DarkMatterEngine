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
    
    func remove(_ entityId: EntityId) throws {
        let index = entityId.id
        guard let location = entities.get(at: index) else {
            throw DarkMatterError.entityNotFound(entityId)
        }
        entities.remove(at: index)
        // update location for affected entity
        let update = remove(at: location)
        let affectedEntity = update.entityId
        let isOk = entities.set(
            at: affectedEntity.id,
            newValue: update.current
        )
        assert(isOk, "Failed to update entity \(entityId) with location \(location). May appear due race condition")
    }
    
    private func remove(at location: EntityLocation) -> StructuralChange.EntityMoved {
        let (affectedEntityId, index) = chunks[location.chunkIndex]
            .remove(at: location.index)
        let affectedLocation = EntityLocation(
            chunkIndex: location.chunkIndex,
            index: index
        )
        return .init(
            entityId: affectedEntityId,
            current: affectedLocation
        )
    }
    
    func append(_ components: [Component]) throws -> EntityId {
        // reserve the slot for a new entity
        let index = entities.append(.invalid)
        let entityId = EntityId(id: index)
        do {
            let location = try append(entityId, components)
                .location
            // replace fake value with the correct location
            let isOk = entities.set(at: index, newValue: location)
            assert(isOk, "Failed to update entity \(entityId) with location \(location). May appear due race condition")
        } catch {
            // undo changes and re-throw error
            entities.remove(at: index)
            throw error
        }
        return entityId
    }

    private func append(
        _ entityId: EntityId,
        _ components: [Component]
    ) throws -> StructuralChange.EntityInserted {
        let canonizedComponents = try components.canonize(orderMap)
        let canonizedIds = canonizedComponents.canonizedIdentifiers()
        let chunkIndex = try findFreeChunk(canonizedIds) ?? pushNewChunk(canonizedIds)
        let index = try chunks[chunkIndex].uncheckedAppend(entityId, canonizedComponents)
        let location = EntityLocation(
            chunkIndex: chunkIndex,
            index: index
        )
        return .init(
            entityId: entityId,
            location: location
        )
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
}

struct EntityLocation: Hashable {
    let chunkIndex: Int
    let index: Int
    
    static let invalid = Self(
        chunkIndex: -1,
        index: -1
    )
    
    var isValid: Bool {
        chunkIndex >= 0 && index >= 0
    }
}

enum StructuralChange {
    struct EntityInserted {
        let entityId: EntityId
        let location: EntityLocation
    }
    
    struct EntityMoved {
        let entityId: EntityId
        let current: EntityLocation
    }
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
