//
//  FinalArray.swift
//  DarkMatterWorld
//
//  Created by Sergey on 16.11.2025.
//

import Foundation

struct FinalArray<T>: Sequence {
    private let array: [T]
    
    init(_ array: [T]) {
        self.array = array
    }
    
    var count: Int {
        array.count
    }
    
    func makeIterator() -> IndexingIterator<Array<T>> {
        array.makeIterator()
    }
}

extension FinalArray: Equatable where T: Equatable {
    // no op
}

extension FinalArray: Hashable where T: Hashable {
    // no op
}
