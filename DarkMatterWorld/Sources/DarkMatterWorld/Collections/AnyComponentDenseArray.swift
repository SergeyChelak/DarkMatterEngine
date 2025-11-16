//
//  AnyDenseArray.swift
//  DarkMatterWorld
//
//  Created by Sergey on 13.11.2025.
//

import Foundation

struct AnyComponentDenseArray {
    // Stores the type-erased instance
    private var internalStorage: AnyComponentArray

    // Initializer using a generic type to create the underlying storage
    init<T: Component>(for type: T.Type, capacity: Int) {
        self.internalStorage = DenseComponentArray(
            DenseArray<T>(capacity: capacity)
        )
    }
    
    var count: Int {
        internalStorage.count
    }
    
//    var componentType: any Component.Type {
//        internalStorage.componentType
//    }
    
    mutating func append(_ component: any Component) throws {
        try internalStorage.appendUntyped(component)
    }
    
    mutating func remove(at index: Int) -> (any Component)? {
        internalStorage.remove(at: index)
    }
        
    func get(at index: Int) -> any Component {
        internalStorage.getUntyped(at: index)
    }
    
    mutating func set(at index: Int, _ value: any Component) throws {
        try internalStorage.setUntyped(at: index, value: value)
    }
    
    subscript(index: Int) -> any Component {
        get { get(at: index )}
        set { try! set(at: index, newValue) }
    }
}

extension AnyComponentDenseArray: Sequence {
    func makeIterator() -> AnyIterator<(any Component)> {
        var index = 0
        return AnyIterator {
            guard index < count else {
                return nil
            }
            let value = get(at: index)
            index += 1
            return value
        }
    }
}

private protocol AnyComponentArray  {
//    var componentType: any Component.Type { get }
    
    var count: Int { get }

    mutating func appendUntyped(_ component: any Component) throws
    
    mutating func remove(at index: Int) -> (any Component)?
    
    func getUntyped(at index: Int) -> any Component
    
    mutating func setUntyped(at index: Int, value: any Component) throws
}

// This struct wraps the generic DenseArray<T> and conforms to the non-generic protocol
private struct DenseComponentArray<T: Component>: AnyComponentArray {
    private var denseArray: DenseArray<T>
    
    init(_ denseArray: DenseArray<T>) {
        self.denseArray = denseArray
    }
    
//    var componentType: any Component.Type {
//        T.self
//    }
    
    var count: Int {
        denseArray.count
    }
    
    mutating func appendUntyped(_ component: any Component) throws {
        let specificComponent = try specificComponent(component)
        denseArray.append(specificComponent)
    }
    
    mutating func remove(at index: Int) -> (any Component)? {
        denseArray.remove(at: index)
    }

    func getUntyped(at index: Int) -> any Component {
        denseArray[index]
    }
    
    mutating func setUntyped(at index: Int, value: any Component) throws {
        denseArray[index] = try specificComponent(value)
    }
    
    // Type checking happens here! Only allow insertion of the correct type T
    private func specificComponent(_ component: any Component) throws -> T {
        guard let specificComponent = component as? T else {
            let message = "Error: Tried to insert \(type(of: component)) into array of \(T.self)"
            throw DarkMatterError.unexpectedComponentType(message)
        }
        return specificComponent
    }
}
