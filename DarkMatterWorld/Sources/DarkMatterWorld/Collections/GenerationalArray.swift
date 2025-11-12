//
//  GenerationalArray.swift
//  DarkMatterWorld
//
//  Created by Sergey on 12.11.2025.
//

import Foundation

struct GenerationalArray<T> {
    private struct Element {
        let value: T
        let generation: UInt64
    }
    
    private var array: [Element]
    
    subscript(index: StableIndex) -> T? {
        get {
            fatalError()
        }
//        Not sure if setter is needed
//        set {
//            fatalError()
//        }
    }
    
    mutating func append(_ element: T) -> StableIndex {
        fatalError()
    }
    
    mutating func remove(_ index: StableIndex) -> T {
        fatalError()
    }
}

struct StableIndex: Hashable, Codable, Equatable, Sendable {
    let index: Int
    let generation: UInt64
}
