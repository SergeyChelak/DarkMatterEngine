//
//  CompactArray.swift
//  DarkMatterStorage
//
//  Created by Sergey on 31.10.2025.
//

import Foundation

struct CompactArray<T> {
    private var array: [T]
    fileprivate var length: Int
    
    public init(_ array: [T] = []) {
        self.array = array
        self.length = array.count
    }
    
    public var count: Int {
        length
    }
    
    public mutating func append(_ value: T) {
        if array.count > length {
            array[length] = value
            length += 1
            return
        }
        
        array.append(value)
        self.length = array.count
    }
    
    @discardableResult
    public mutating func delete(
        _ index: Int,
    ) -> T? {
        guard length > 0 else {
            return nil
        }
        let lastIndex = self.length - 1
        let value = self.array[index]
        self.array[index] = self.array[lastIndex]
        self.length -= 1        
        return value
    }
    
    public subscript(_ index: Int) -> T {
        self.array[index]
    }
}

extension CompactArray: Collection {
    public func index(after i: Int) -> Int {
        self.array.index(after: i)
    }
    
    public var startIndex: Int {
        0
    }
    
    public var endIndex: Int {
        self.length
    }
    
    public func makeIterator() -> IndexingIterator<ArraySlice<T>> {
        self.slice.makeIterator()
    }
}

extension CompactArray {
    var slice: ArraySlice<T> {
        self.array.prefix(self.length)
    }
    
    var debugAllocatedCount: Int {
        self.array.count
    }
}

func ==<T>(
    lhs: CompactArray<T>,
    rhs: [T]
) -> Bool where T: Equatable {
    guard lhs.length == rhs.count else {
        return false
    }
    return zip(lhs.slice, rhs).allSatisfy { (a, b) in
        a == b
    }
}
