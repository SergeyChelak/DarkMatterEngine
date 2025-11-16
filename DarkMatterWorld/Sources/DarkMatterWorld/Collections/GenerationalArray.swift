//
//  GenerationalArray.swift
//  DarkMatterWorld
//
//  Created by Sergey on 12.11.2025.
//

import Foundation

struct GenerationalArray<T> {
    private struct InnerElement {
        // Custom optional added to disambiguate cases when T is optional too
        enum Opt {
            case some(T), empty
        }
        
        let store: Opt
        let generation: UInt64
        
        static func some(
            value: T,
            generation: UInt64
        ) -> Self {
            Self(
                store: .some(value),
                generation: generation
            )
        }
        
        static func empty(
            generation: UInt64
        ) -> Self {
            Self(
                store: .empty,
                generation: generation
            )
        }
    }
    
    private var recycledIndices: [Int] = []
    private var array: [InnerElement]
    private(set) var count: Int
    
    init(capacity: Int = 16) {
        self.array = .with(capacity: capacity)
        self.count = 0
    }
    
    var isEmpty: Bool {
        self.count == 0
    }
    
    subscript(index: StableIndex) -> T? {
        get { get(at: index) }
        set { set(at: index, newValue: newValue!) }
    }
    
    func get(at index: StableIndex) -> T? {
        let idx = index.slot
        let element = self.array[idx]
        guard element.generation == index.generation,
              case(.some(let value)) = element.store  else {
            return nil
        }
        return value
    }
    
    @discardableResult
    mutating func set(at index: StableIndex, newValue: T) -> Bool {
        let idx = index.slot
        let element = self.array[idx]
        guard element.generation == index.generation else {
            return false
        }
        self.array[idx] = .some(
            value: newValue,
            generation: index.generation
        )
        return true
    }
    
    @discardableResult
    mutating func append(_ value: T) -> StableIndex {
        self.count += 1
        return if let index = recycledIndices.popLast() {
            recycle(at: index, value)
        } else {
            pushBack(value)
        }
    }
    
    private mutating func recycle(at position: Int, _ value: T) -> StableIndex {
        let generation = self.array[position].generation
        let index = StableIndex(
            slot: position,
            generation: generation
        )
        let element: InnerElement = .some(
            value: value,
            generation: index.generation
        )
        self.array[position] = element
        return index
    }
    
    private mutating func pushBack(_ value: T) -> StableIndex {
        let index = StableIndex(
            slot: self.totalCount,
            generation: 0
        )
        let value: InnerElement = .some(
            value: value,
            generation: index.generation
        )
        self.array.append(value)
        return index
    }
    
    @discardableResult
    mutating func remove(at index: StableIndex) -> T? {
        let idx = index.slot
        let current = self.array[idx]
        guard current.generation == index.generation,
            case(.some(let value)) = current.store  else {
            return nil
        }
        recycledIndices.append(idx)
        self.array[idx] = .empty(
            // Use wrapping addition (&+) to avoid crash due type overflow
            generation: current.generation &+ 1
        )
        self.count -= 1
        return value
    }
}

extension GenerationalArray: Sequence {
    public func makeIterator() -> GenerationalArrayIterator {
        GenerationalArrayIterator(self)
    }
    
    struct GenerationalArrayIterator: IteratorProtocol {
        typealias Element = T

        private let array: GenerationalArray<T>
        private var currentIndex: Int = 0
        
        init(_ array: GenerationalArray<T>) {
            self.array = array
        }
        
        mutating func next() -> T? {
            while currentIndex < array.totalCount {
                let element = array.array[currentIndex]
                currentIndex += 1
                if case .some(let value) = element.store {
                    return value
                }
            }
            return nil
        }
    }
}

extension GenerationalArray {
    var totalCount: Int {
        array.count
    }
    #if DEBUG
    func _generation(at index: Int) -> UInt64 {
        self.array[index].generation
    }
    
    func _array() -> [T] {
        self.array
            .compactMap {
                guard case(.some(let value)) = $0.store else {
                    return nil
                }
                return value
            }
    }
    #endif
}

struct StableIndex: Hashable, Codable, Equatable, Sendable {
    let slot: Int
    let generation: UInt64
}
