//
//  RecyclableArrayTest.swift
//  DarkMatterStorage
//
//  Created by Sergey on 01.11.2025.
//

import XCTest
@testable import DarkMatterStorage

final class RecyclableArrayTest: XCTestCase {
    func testSequentialInsert() {
        var recycler = RecyclableArray<String>()
        
        XCTAssertEqual(recycler.append("Something"), RecyclableArray.Position(index: 0, generation: 0))
        XCTAssertEqual(recycler.append("white"), RecyclableArray.Position(index: 1, generation: 0))
        XCTAssertEqual(recycler.append("something"), RecyclableArray.Position(index: 2, generation: 0))
        XCTAssertEqual(recycler.append("black"), RecyclableArray.Position(index: 3, generation: 0))
    }
    
    func testRemoveElement() {
        var recycler: RecyclableArray = .from(["Something", "right", "something", "wrong"]);
        XCTAssertEqual(recycler[0, 0], "Something")
        recycler.remove(at: 0)
        XCTAssertEqual(recycler[0, 0], nil)
    }
    
    func testMultipleCycling() {
        var recycler: RecyclableArray = .from(["Something", "right", "something", "wrong"]);
        for gen: UInt64 in 1...10 {
            recycler.remove(at: 0)
            let pos = recycler.append("Anything")
            XCTAssertEqual(pos, RecyclableArray.Position(index: 0, generation: gen))
            XCTAssertEqual(recycler[pos], "Anything")
        }
    }
    
    func testWrongGenerationAccess() {
        var recycler: RecyclableArray = .from(["Something", "right", "something", "wrong"]);
        recycler.remove(at: 0)
        XCTAssertEqual(recycler[0, 1],  nil)
    }
    
    func testCycleAndAppend() {
        var recycler: RecyclableArray = .from(["Something", "right", "something", "wrong"]);
        recycler.remove(at: 0)
        recycler.remove(at: 1)
        let p1 = recycler.append("Everything")
        XCTAssertEqual(p1, RecyclableArray.Position(index: 1, generation: 1))
        let p2 = recycler.append("different")
        XCTAssertEqual(p2, RecyclableArray.Position(index: 0, generation: 1))
        let p3 = recycler.append("last")
        XCTAssertEqual(p3, RecyclableArray.Position(index: 4, generation: 0))
    }
}

fileprivate extension RecyclableArray {
    static func from(_ collection: any Collection<T>) -> Self {
        var recycler = RecyclableArray()
        collection.forEach {
            _ = recycler.append($0)
        }
        return recycler
    }
}
