//
//  ArchetypeKeyTest.swift
//  DarkMatterStorage
//
//  Created by Sergey on 31.10.2025.
//

import XCTest
@testable import DarkMatterStorage

final class ArchetypeKeyTest: XCTestCase {
    struct C1: Component {}
    struct C2: Component {}
    struct C3: Component {}
    struct C4: Component {}
    struct C5: Component {}
    
    func testSetupArchetypeKeyWithUniqueValues() throws {
        let key: ArchetypeKey = .with([
            C1(), C2(), C3(), C4(), C5()
        ])
        XCTAssertEqual(key.count, 5)
    }
    
    func testSetupArchetypeKeyWithRepeatingValues() throws {
        let key: ArchetypeKey = .with([
            C1(), C1(), C3(), C3(), C5()
        ])
        XCTAssertEqual(key.count, 3)
    }
    
    func testSetupArchetypeKeyWithUniqueComponents() throws {
        let key: ArchetypeKey = .with([
            C1.self, C2.self, C3.self, C4.self, C5.self
        ])
        XCTAssertEqual(key.count, 5)
    }
    
    func testSetupArchetypeKeyWithRepeatableComponents() throws {
        let key: ArchetypeKey = .with([
            C1.self, C2.self, C2.self, C5.self, C5.self
        ])
        XCTAssertEqual(key.count, 3)
    }
    
    func testIsKindOfOtherKeyWithSubsetComponents() throws {
        let actualArchetype: ArchetypeKey = .with([
            C1.self, C2.self, C3.self, C4.self, C5.self
        ])
        
        let searchArchetype: ArchetypeKey = .with([
            C1.self, C2.self
        ])
        
        XCTAssert(actualArchetype.isKindOf(searchArchetype))
    }
    
    func testIsKindOfOtherKeyWithSameComponents() throws {
        let actualArchetype: ArchetypeKey = .with([
            C1.self, C2.self, C3.self, C4.self, C5.self
        ])
        
        let searchArchetype: ArchetypeKey = .with([
            C1.self, C2.self, C3.self, C4.self, C5.self
        ])
        
        XCTAssert(actualArchetype.isKindOf(searchArchetype))
    }
    
    func testIsNotKindOfOtherKey() throws {
        let actualArchetype: ArchetypeKey = .with([
            C1.self, C2.self, C3.self, C4.self
        ])
        
        let searchArchetype: ArchetypeKey = .with([
            C1.self, C2.self, C5.self
        ])
        
        XCTAssert(!actualArchetype.isKindOf(searchArchetype))
    }
    
    func testKeysAreEquals() throws {
        let actualArchetype: ArchetypeKey = .with([
            C1.self, C2.self, C3.self, C4.self, C5.self
        ])
        
        let searchArchetype: ArchetypeKey = .with([
            C1.self, C5.self, C3.self, C4.self, C2.self
        ])
        
        XCTAssert(actualArchetype.isEquals(searchArchetype))
    }
    
    func testKeysAreNotEquals() throws {
        let actualArchetype: ArchetypeKey = .with([
            C1.self, C2.self, C3.self, C5.self
        ])
        
        let searchArchetype: ArchetypeKey = .with([
            C1.self, C3.self, C4.self, C5.self
        ])
        
        XCTAssert(!actualArchetype.isEquals(searchArchetype))
    }
}
