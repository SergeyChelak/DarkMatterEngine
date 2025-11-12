//
//  EntityStorageBuilder.swift
//  DarkMatterWorld
//
//  Created by Sergey on 11.11.2025.
//

import Foundation

public struct EntityStorageBuilder {
    private var components: [Component.Type]
    private var componentCapacity: Int = 1_000
    
    func register<T: Component>(_ type: T.Type) -> Self {
        // component already included
        guard components.allSatisfy({ $0.componentId != type.componentId }) else {
            return self
        }
        var new = self
        new.components.append(type)
        return new
    }
    
    func componentCapacity(_ value: Int) -> Self {
        var new = self
        new.componentCapacity = value
        return new
    }
    
    func build() -> EntityStorage {
        EntityStorage(
            components: self.components
        )
    }
}
