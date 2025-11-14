//
//  EntityStorage.swift
//  DarkMatterWorld
//
//  Created by Sergey on 11.11.2025.
//

import Foundation

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
