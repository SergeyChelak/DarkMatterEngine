//
//  Entity.swift
//  DarkMatterWorld
//
//  Created by Sergey on 01.11.2025.
//

import Foundation

public struct EntityId: Hashable, Codable, Equatable, Sendable {
    public let id: Int
    public let generation: UInt64
}

public protocol EntityCommand {
    func spawn() -> EntitySpawner
    
    func spawn(with components: [Component])
    
    func read(_ entityId: EntityId) -> EntityProjection
    
    func modify(_ entityId: EntityId) -> EntityModifier
    
    func despawn(_ entityId: EntityId) -> EntityDespawner
}

public protocol EntityModifier: Committable {
    func add(_ component: Component)
    
    func remove<T: Command>(_ type: T.Type)
}

public protocol EntitySpawner {
    //
}

public protocol EntityDespawner {
    //
}
