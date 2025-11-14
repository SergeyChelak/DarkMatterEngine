//
//  EntityCommand.swift
//  DarkMatterWorld
//
//  Created by Sergey on 05.11.2025.
//

import Foundation

public protocol EntityCommand {
    /// Spawn entity thru builder pattern
    /// Action will be executed at the end of frame
    func spawn() -> EntityBuilder
    
    /// Spawn entity from specified set of components
    /// Action will be executed at the end of frame
    func spawn(with components: [Component])

    /// Structural entity modification
    /// Action will be executed at the end of frame
    func modify(_ entityId: EntityId) -> EntityModifier
    
    /// Removes entity from storage
    /// Action will be executed at the end of frame
//    func despawn(_ entityId: EntityId) -> EntityDespawner
}


public protocol EntityModifier {
    func add(_ component: Component)
    
    func remove<T: Component>(_ type: T.Type)
}


public protocol EntityBuilder {
    func add(_ component: Component) -> Self
}
