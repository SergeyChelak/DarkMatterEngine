//
//  ComponentRegistry.swift
//  DarkMatterWorld
//
//  Created by Sergey on 12.11.2025.
//

import Foundation

final class ComponentRegistry {
    private let orderMap: [ComponentIdentifier: Int]
    
    typealias DenseFactory = [ComponentIdentifier: DenseArray<any Component>]
    private var denseFactory: DenseFactory = [:]
    
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
            guard let left = orderMap[l.componentId] else {
                throw DarkMatterError.unknownComponent(l)
            }
            guard let right = orderMap[r.componentId] else {
                throw DarkMatterError.unknownComponent(r)
            }
            guard left != right else {
                throw DarkMatterError.componentAddedMultipleTimes(l)
            }
            return left < right
        }
        return OrderedComponents(ordered)
    }
}

/// `OrderedComponents` could be created with `ComponentRegistry`
/// It's expected that `ComponentRegistry` guarantees
/// - deterministic order
/// - exclusive component types
typealias OrderedComponents = FinalArray<Component>

extension OrderedComponents {
    func identifiers() -> OrderedComponentIdentifiers {
        let raw = self.array.map { $0.componentId }
        return OrderedComponentIdentifiers(raw)
    }
}

typealias OrderedComponentIdentifiers = FinalArray<ComponentIdentifier>

struct FinalArray<T>: Sequence {
    let array: [T]
    
    fileprivate init(_ array: [T]) {
        self.array = array
    }
    
    var count: Int {
        array.count
    }
    
    func makeIterator() -> IndexingIterator<Array<T>> {
        array.makeIterator()
    }
}
