//
//  CompactArrayTest.swift
//  DarkMatterECSTests
//
//  Created by Sergey on 29.10.2025.
//

import XCTest
@testable import DarkMatterECS

final class CompactArrayTest: XCTestCase {
    typealias CompactIntArray = CompactArray<Int>
    
    func testIterator() throws {
        let src = [1, 3, 5, 7]
        let array = CompactIntArray(src)
        for (i, val) in array.enumerated() {
            XCTAssertEqual(val, src[i])
        }
    }
    
    func testInsert() throws {
        var arr: CompactIntArray = .init()
        XCTAssertEqual(arr.count, 0)
        arr.append(1)
        arr.append(2)
        XCTAssertEqual(arr.count, 2)
        XCTAssertEqual(arr.debugAllocatedCount, 2)
    }
    
    func testDelete() throws {
        let src = [0, 1, 2, 3, 4, 5, 6, 7]
        var array = CompactIntArray(src)
        XCTAssertEqual(array.count, 8)
        array.delete(2)
        XCTAssert(array == [0, 1, 7, 3, 4, 5, 6])
        array.delete(3)
        XCTAssert(array == [0, 1, 7, 6, 4, 5])
    }
    
    func testDeleteInsert() throws {
        let src = [0, 1, 2, 3, 4, 5, 6, 7]
        var array = CompactIntArray(src)
        array.delete(2)
        array.delete(3)
        array.append(8)
        XCTAssert(array == [0, 1, 7, 6, 4, 5, 8])
        array.delete(0)
        XCTAssert(array == [8, 1, 7, 6, 4, 5])
        array.append(9)
        array.append(10)
        XCTAssert(array == [8, 1, 7, 6, 4, 5, 9, 10])
    }
}
