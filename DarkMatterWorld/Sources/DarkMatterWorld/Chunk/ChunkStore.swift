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
    
    func remove(at location: EntityLocation) -> StructuralChange.EntityMoved {
        fatalError()
    }
    
    // Public method. Move it to the protocol
    func append(_ components: [Component]) throws -> StructuralChange.EntityInserted {
        let canonizedComponents = try components.canonize(orderMap)
        let canonizedIds = canonizedComponents.canonizedIdentifiers()
        let chunkIndex = try findFreeChunk(canonizedIds) ?? pushNewChunk(canonizedIds)
        let index = try chunks[chunkIndex].append(canonizedComponents)
        let location = EntityLocation(
            chunkIndex: chunkIndex,
            index: index
        )
        return StructuralChange.EntityInserted(location: location)
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
}

enum StructuralChange {
    struct EntityInserted {
        let location: EntityLocation
    }
    
    struct EntityMoved {
        let previous: EntityLocation
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
