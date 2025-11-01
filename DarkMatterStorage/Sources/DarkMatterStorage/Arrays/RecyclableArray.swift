//
//  RecyclableArray.swift
//  DarkMatterStorage
//
//  Created by Sergey on 01.11.2025.
//

import Foundation

struct RecyclableArray<T> {
    typealias Generation = UInt64
    
    struct Position: Equatable {
        let index: Int
        let generation: Generation
    }
    
    struct Holder {
        let value: T?
        let generation: Generation
    }
    
    private var recycledIndices: [Int] = []
    private var store: [Holder] = []
    
    subscript(position: Position) -> T? {
        self[position.index, position.generation]
    }
    
    subscript(index: Int, generation: Generation) -> T? {
        let holder = store[index]
        return holder.generation == generation ? holder.value : nil
    }
    
    mutating func append(_ value: T) -> Position {
        if let index = recycledIndices.popLast() {
            let generation = store[index].generation
            store[index] = Holder(
                value: value,
                generation: generation
            )
            return Position(
                index: index,
                generation: generation
            )
        }
        
        let holder = Holder(
            value: value,
            generation: 0
        )
        store.append(holder)
        return Position(index: store.count - 1, generation: 0)
    }
    
    @discardableResult
    mutating func remove(at index: Int) -> T? {
        let holder = store[index]
        if holder.value != nil {
            store[index] = Holder(
                value: nil,
                generation: holder.generation + 1
            )
            recycledIndices.append(index)
        }
        return holder.value
    }
}
