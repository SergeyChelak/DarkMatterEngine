//
//  CanonizedComponents.swift
//  DarkMatterWorld
//
//  Created by Sergey on 16.11.2025.
//

import Foundation

typealias CanonizedComponents = FinalArray<Component>
typealias CanonizedComponentIdentifiers = FinalArray<ComponentIdentifier>

extension CanonizedComponents {
    func canonizedIdentifiers() -> CanonizedComponentIdentifiers {
        let raw = map { $0.componentId }
        return CanonizedComponentIdentifiers(raw)
    }
}

extension Array where Element == Component {
    func identifiers() -> [ComponentIdentifier] {
        map { $0.componentId }
    }
    
    func canonize(
        _ orderMap: ComponentOrderMap
    ) throws -> CanonizedComponents {
        try canonize(orderMap) { $0.componentId }
    }
}

extension Array where Element == ComponentIdentifier {
    func canonize(
        _ orderMap: ComponentOrderMap
    ) throws -> CanonizedComponentIdentifiers {
        try canonize(orderMap) { $0 }
    }
}

extension Array {
    func canonize(
        _ orderMap: ComponentOrderMap,
        transform: (Element) -> ComponentIdentifier
    ) throws -> FinalArray<Element> {
        let ordered = try sorted { first, second in
            let l = transform(first)
            let r = transform(second)
            guard let left = orderMap[l] else {
                throw DarkMatterError.unknownComponent(l)
            }
            guard let right = orderMap[r] else {
                throw DarkMatterError.unknownComponent(r)
            }
            guard left != right else {
                throw DarkMatterError.componentAddedMultipleTimes(l)
            }
            return left < right
        }
        return FinalArray(ordered)
    }
}
