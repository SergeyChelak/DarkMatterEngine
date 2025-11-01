//
//  Archetype.swift
//  DarkMatterStorage
//
//  Created by Sergey on 31.10.2025.
//

import Foundation

/// Storage for components with a specific archetype
public class Archetype {
    private let key: ArchetypeKey
    private var identifiers: CompactArray<EntityId> = .init()
    private var components: [AnyComponentArray] = []

    public init(_ key: ArchetypeKey) {
        self.key = key
        // initialize component dictionary
//        for id in key.data {
//            components[id] = ComponentArray()
//        }
    }
    /*
    func add(
        id: EntityId,
        components: ComponentArray
    ) throws -> EntityPosition {
        guard self.key.isEquals(.with(components)) else {
            throw StorageError.invalidArchetype
        }
        identifiers.append(id)
        for component in components {
            let id = type(of: component).componentId
            self.components[id]?.append(component)
        }
  
        return EntityPosition(
            entityId: id,
            position: identifiers.count - 1
        )
    }
        
    func remove(at index: Int) throws -> UpdatedArrayPosition {
        let count = identifiers.count
        guard count > 0, index < count else {
            throw StorageError.indexOutOfBound(index, count)
        }
        
        for (id, _) in components {
            self.components[id]?.delete(index)
        }
        
        identifiers.delete(index)
        
        return UpdatedArrayPosition(
            previous: count - 1,
            current: index
        )
    }
 */
}

public struct ArchetypeKey: Hashable {
    let data: Set<ComponentIdentifier>
    
    var count: Int {
        self.data.count
    }
    
    func isKindOf(_ other: ArchetypeKey) -> Bool {
        self.data.isSuperset(of: other.data)
    }
    
    func isEquals(_ other: ArchetypeKey) -> Bool {
        self.data == other.data
    }
    
    static func with(_ types: [Component.Type]) -> Self {
        let identifiers = Set(types.map { $0.componentId })
        return Self(data: identifiers)
    }
    
    static func with(_ values: any Collection<Component>) -> Self {
        let identifiers = Set(values.map { type(of: $0).componentId })
        return Self(data: identifiers)
    }
}
