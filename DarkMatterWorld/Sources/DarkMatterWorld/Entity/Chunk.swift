//
//  Chunk.swift
//  DarkMatterWorld
//
//  Created by Sergey on 13.11.2025.
//

import Foundation

final class Chunk {
    private var count: Int = 0
    private var data: [DenseArray<Component>] = []
    private let identifiers: OrderedComponentIdentifiers
    private let size: Int
    
    init(
        identifiers: OrderedComponentIdentifiers,
        size: Int
    ) {
        // TODO: create storage outside
        for _ in identifiers {
            let row = DenseArray<Component>(capacity: size)
            data.append(row)
        }

        self.size = size
        self.identifiers = identifiers
    }
    
    var freeSlots: Int {
        size - count
    }
    
    /// Append to chunk a new entity with given components
    /// If archetypes don't match throws error
    /// otherwise return slot index of brand new entity
    func append(_ components: OrderedComponents) throws -> Int {
        guard freeSlots > 0 else {
            throw DarkMatterError.chunkOverflow
        }
        guard components.count == identifiers.count else {
            throw DarkMatterError.archetypeMismatch
        }
        let slot = self.count
        for (idx, (input, id)) in zip(components, self.identifiers).enumerated() {
            guard input.componentId == id else {
                throw DarkMatterError.archetypeMismatch
            }
            data[idx].append(input)
        }
        self.count += 1
        return slot
    }
}
