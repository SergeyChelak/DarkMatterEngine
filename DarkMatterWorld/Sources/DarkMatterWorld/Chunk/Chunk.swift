//
//  Chunk.swift
//  DarkMatterWorld
//
//  Created by Sergey on 13.11.2025.
//

import Foundation

final class Chunk {
    private var entities: DenseArray<EntityId>
    private var data: [AnyComponentDenseArray] = []
    private let identifiers: CanonizedComponentIdentifiers
    private let size: Int
    
    init(
        identifiers: CanonizedComponentIdentifiers,
        data: [AnyComponentDenseArray],
        size: Int
    ) {
        self.entities = .init(capacity: size)
        self.identifiers = identifiers
        self.data = data
        self.size = size
    }
    
    var count: Int {
        entities.count
    }
    
    var hasFreeSlots: Bool {
        size > count
    }
    
    /// Append to chunk a new entity with given components
    /// If archetypes don't match throws error
    /// otherwise return slot index of brand new entity
//    func append(
//        _ entityId: EntityId,
//        _ components: CanonizedComponents
//    ) throws -> Int {
//        guard components.canonizedIdentifiers() == identifiers else {
//            throw DarkMatterError.archetypeMismatch
//        }
//        return try uncheckedAppend(entityId, components)
//    }
    
    func uncheckedAppend(
        _ entityId: EntityId,
        _ components: CanonizedComponents
    ) throws -> Int {
        for (idx, input) in components.enumerated() {
            try data[idx].append(input)
        }
        let slot = self.count
        entities.append(entityId)
        return slot
    }
    
    func remove(at index: Int) -> (EntityId, Int) {
        for var row in data {
            row.remove(at: index)
        }
        let id = entities[count - 1]
        entities.remove(at: index)
        return (id, entities.count)
    }
}
