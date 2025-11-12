//
//  DenseArray.swift
//  DarkMatterWorld
//
//  Created by Sergey on 12.11.2025.
//

import Foundation

struct DenseArray<T> {
    private var array: [T]
    private(set) var count: Int
    
    init(capacity: Int = 16) {
        self.array = .with(capacity: capacity)
        self.count = 0
    }
    
    init(_ array: [T]) {
        self.array = array
        self.count = array.count
    }
    
    var isEmpty: Bool {
        self.count == 0
    }
    
    subscript(index: Int) -> T {
        get {
            self.array[index]
        }
        set {
            self.array[index] = newValue
        }
    }
    
    mutating func append(_ element: T) {
        if self.count == self.array.count {
            self.array.append(element)
        } else {
            self.array[count] = element
        }
        self.count += 1
    }
    
    @discardableResult
    mutating func remove(at index: Int) -> T {
        self.count -= 1
        self.array.swapAt(index, self.count)
        return self.array[self.count]
    }
}

extension DenseArray: Sequence {
    public func makeIterator() -> IndexingIterator<ArraySlice<T>> {
        self._slice().makeIterator()
    }
}

extension DenseArray: Equatable where T: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs._slice() == rhs._slice()
    }
}

extension DenseArray {
    func _slice() -> ArraySlice<T> {
        self.array.prefix(self.count)
    }
    
    func _array() -> [T] {
        Array(self._slice())
    }
    
    var _totalCount: Int {
        self.array.count
    }
}
