//
//  Component.swift
//  DarkMatterStorage
//
//  Created by Sergey on 31.10.2025.
//

import Foundation

public typealias ComponentIdentifier = ObjectIdentifier

public protocol Component: Codable, Sendable {
    static var componentId: ComponentIdentifier { get }
}

extension Component {
    static var componentId: ComponentIdentifier {
        ComponentIdentifier(Self.self)
    }
}

// MARK: - Type-Erased Component Storage
public protocol AnyComponentArray {
    /// The ComponentIdentifier for the type this array holds.
    var componentId: ComponentIdentifier { get }
    
    /// Type-erased append function. Accepts a Component protocol instance.
    func append(_ component: Component) throws
    
    /// Type-erased delete function (swap-and-pop).
    func delete(at index: Int)
}

class ComponentArray<T: Component>: AnyComponentArray {
    private var store: CompactArray<T> = .init()
    
    public init(_ collection: any Collection<T>) {
        collection.forEach {
            store.append($0)
        }
    }
    
    var componentId: ComponentIdentifier {
        T.componentId
    }
    
    func append(_ component: Component) throws {
        guard let value = component as? T else {
            throw StorageError.invalidComponentType
        }
        self.store.append(value)
    }
    
    func delete(at index: Int) {
        store.delete(index)
    }
    
    public subscript(index: Int) -> T {
        store[index]
    }
}
