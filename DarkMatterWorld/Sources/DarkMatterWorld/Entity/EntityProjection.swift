//
//  EntityProjection.swift
//  DarkMatterWorld
//
//  Created by Sergey on 05.11.2025.
//

import Foundation

public protocol EntityProjection {
    var entityId: EntityId { get }
    
    func get<T>(_ component: T.Type) -> T?

    func set<T>(_ component: T)
}
