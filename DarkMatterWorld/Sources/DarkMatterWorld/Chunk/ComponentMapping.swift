//
//  ComponentMapping.swift
//  DarkMatterWorld
//
//  Created by Sergey on 17.11.2025.
//

import DarkMatterCore

typealias ComponentTypeMap = [ComponentIdentifier: Component.Type]

extension ComponentTypeMap {
    static func with(_ components: [Component.Type]) -> Self {
        var map = Self()
        for component in components {
            let id = component.componentId
            map[id] = component
        }
        return map
    }
}

typealias ComponentOrderMap = [ComponentIdentifier: Int]

extension ComponentOrderMap {
    static func with<T: Sequence>(
        _ components: T,
        mapper: (T.Element) -> ComponentIdentifier
    ) -> Self {
        var orderMap = Self()
        for (index, component) in components.enumerated() {
            let id = mapper(component)
            orderMap[id] = index
        }
        return orderMap
    }
}

