//
//  ChunkStore.swift
//  DarkMatterWorld
//
//  Created by Sergey on 16.11.2025.
//

import Foundation

final class ChunkStore {
    struct Location {
        let chunkIndex: Int
        let index: Int
    }
    
    private let typeMap: ComponentTypeMap
    private let orderMap: ComponentOrderMap
    private let chunkSize: Int
    // TODO: replace with hashmap to improve chunk search
    private var chunks: [Chunk] = []
        
    init(
        components: [Component.Type],
        chunkSize: Int
    ) {
        self.typeMap = .with(components)
        self.orderMap = .with(components)
        self.chunkSize = chunkSize
    }
    
    func append(_ components: [Component]) throws -> Location {
        let canonizedComponents = try components.canonize(orderMap)
        let canonizedIds = canonizedComponents.canonizedIdentifiers()
        let chunkIndex = try findFreeChunk(canonizedIds) ?? pushNewChunk(canonizedIds)
        let index = try chunks[chunkIndex].append(canonizedComponents)
        return Location(
            chunkIndex: chunkIndex,
            index: index
        )
    }
    
    private func pushNewChunk(
        _ canonizedIds: CanonizedComponentIdentifiers
    ) throws -> Int {
        let index = chunks.count
        let chunk = try allocateChunk(for: canonizedIds, count: chunkSize)
        chunks.append(chunk)
        return index
    }
    
    private func findFreeChunk(
        _ identifiers: CanonizedComponentIdentifiers
    ) -> Int? {
        for (index, chunk) in chunks.enumerated() {
            guard chunk.isType(of: identifiers) else {
                continue
            }
            if chunk.hasFreeSlots {
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
