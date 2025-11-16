//
//  EntityCommand.swift
//  DarkMatterWorld
//
//  Created by Sergey on 05.11.2025.
//

import Foundation

public protocol EntityCommand {
    /// Spawn entity from specified set of components
    /// Action will be executed at the end of frame
    func spawn(_ components: [Component])

    /// Structural entity modification
    /// Action will be executed at the end of frame
    func entity(_ entityId: EntityId) -> EntityModifier
}


public protocol EntityModifier {
    func add(_ component: Component) -> EntityModifier
    
    func remove<T: Component>(_ type: T.Type) -> EntityModifier
    
    /// Removes entity from storage
    /// Action will be executed at the end of frame
    func despawn(_ entityId: EntityId)
    
    func get<T>(_ component: T.Type) -> T?

    func set<T>(_ component: T) -> EntityModifier

}
