//
//  Chunk.swift
//  DarkMatterWorld
//
//  Created by Sergey on 13.11.2025.
//

import DarkMatterCore
import Foundation

final class Chunk {
    private var entities: DenseArray<EntityId>
    private var data: [AnyComponentDenseArray] = []
    private let identifiers: CanonizedComponentIdentifiers
    private let size: Int
    private let orderMap: ComponentOrderMap
    
    convenience init(
        identifiers: CanonizedComponentIdentifiers,
        count: Int,
        typeMap: ComponentTypeMap
    ) throws {
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
        self.init(
            identifiers: identifiers,
            data: data,
            size: count
        )
    }
        
    init(
        identifiers: CanonizedComponentIdentifiers,
        data: [AnyComponentDenseArray],
        size: Int
    ) {
        self.entities = .init(capacity: size)
        self.identifiers = identifiers
        self.orderMap = .with(identifiers) { $0 }
        self.data = data
        self.size = size
    }
    
    var count: Int {
        entities.count
    }
    
    var hasFreeSlots: Bool {
        size > count
    }
    
    func get<T: Component>(at index: Int, _ type: T.Type) -> T? {
        guard let row = orderMap[type.componentId] else {
            return nil
        }
        return data[row][index] as? T
    }
    
    func getAllComponents(at index: Int) -> [Component] {
        data.map { $0[index] }
    }
    
    func set<T: Component>(at index: Int, _ value: T) -> Bool {
        guard let row = orderMap[value.componentId] else {
            return false
        }
        data[row][index] = value
        return true
    }
    
    func append(
        _ entityId: EntityId,
        _ components: CanonizedComponents
    ) throws -> Int {
        guard components.canonizedIdentifiers() == identifiers else {
            throw DarkMatterError.archetypeMismatch
        }
        guard hasFreeSlots else {
            throw DarkMatterError.chunkOverflow
        }
        return try uncheckedAppend(entityId, components)
    }
    
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
    
    @discardableResult
    func remove(at index: Int) -> EntityId? {
        for row in 0..<data.count {
            data[row].remove(at: index)
        }
        let id = entities[count - 1]
        entities.remove(at: index)
#if DEBUG
        assert(data.allSatisfy { $0.count == entities.count })
#endif
        return count > 0 ? id : nil
    }
}

/// for tests only
/// don't use these functions for other purposes
#if DEBUG
extension Chunk {
    var _rowCount: Int { data.count }
    var _size: Int { size }
    func _stableIndex(at position: Int) -> StableIndex {
        entities[position].id
    }
    var _entitiesCount: Int { entities.count }
}
#endif
