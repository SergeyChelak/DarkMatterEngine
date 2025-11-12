//
//  EntityStorage.swift
//  DarkMatterWorld
//
//  Created by Sergey on 11.11.2025.
//

import Foundation

struct ComponentRegistry {
    private let orderMap: [ComponentIdentifier: Int]
    
    init(components: [Component.Type]) {
        var orderMap: [ComponentIdentifier: Int] = [:]
        for (index, component) in components.enumerated() {
            let id = component.componentId
            orderMap[id] = index
        }
        self.orderMap = orderMap
    }
    
    func ordered(components: [Component]) throws -> OrderedComponents {
        let ordered = try components.sorted { l, r in
            guard let left = orderMap[l.componentId],
                  let right = orderMap[r.componentId] else {
                //fatalError("Unknown component in type order comparison '\(l)' and '\(r)')")
                throw NSError()
            }
            return left < right
        }
        return OrderedComponents(components: ordered)
    }
}

struct OrderedComponents {
    let components: [Component]
}

public final class EntityStorage {
    private let componentRegistry: ComponentRegistry
    private var chunks: [Chunk] = []
    
    init(
        components: [Component.Type],
    ) {
        self.componentRegistry = ComponentRegistry(components: components)
    }
            
    /// Create entity specified with its `components`
    /// Returns `EntityId` of new entity
    func spawn(_ components: [Component]) -> EntityId {
        fatalError()
    }
    
    /// Remove entity with specified `entityId`
    /// Returns `false` is entity not found, otherwise `true`
    func despawn(_ entityId: EntityId) -> Bool {
        fatalError()
    }
    
    /// Provides access to components of specified entity
    /// Access doesn't mean structural modification of storage
    func entity(_ entityId: EntityId) -> EntityProjection {
        fatalError()
    }

    /// Run specified `query`
    /// Result is a sequence of `EntityProjection`
    // TODO: fix result type
    func execute(_ query: Query) -> any QueryResult {
        fatalError()
    }
}

final class Chunk {
    private var count: Int = 0
    private let capacity: Int
    
    init(
        orderedComponents: OrderedComponents,
        capacity: Int
    ) {
        self.capacity = capacity
    }
}
