//
//  Chunk.swift
//  DarkMatterWorld
//
//  Created by Sergey on 13.11.2025.
//

import Foundation

final class Chunk {
    private var count: Int = 0
    private var data: [AnyComponentDenseArray] = []
    private let identifiers: CanonizedComponentIdentifiers
    private let size: Int
    
    init(
        identifiers: CanonizedComponentIdentifiers,
        data: [AnyComponentDenseArray],
        size: Int
    ) {
        self.identifiers = identifiers
        self.data = data
        self.size = size
    }
    
    var hasFreeSlots: Bool {
        size > count
    }
    
    /// Append to chunk a new entity with given components
    /// If archetypes don't match throws error
    /// otherwise return slot index of brand new entity
    func append(_ components: CanonizedComponents) throws -> Int {
        guard components.count == identifiers.count else {
            throw DarkMatterError.archetypeMismatch
        }
        let slot = self.count
        for (idx, (input, id)) in zip(components, self.identifiers).enumerated() {
            guard input.componentId == id else {
                throw DarkMatterError.archetypeMismatch
            }
            try data[idx].append(input)
        }
        self.count += 1
        return slot
    }
}
