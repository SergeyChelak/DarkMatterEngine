//
//  ChunkStoreTests.swift
//  DarkMatterWorld
//
//  Created by Sergey on 17.11.2025.
//

import XCTest
@testable import DarkMatterWorld

final class ChunkStoreTests: XCTestCase {
    struct C1: Component {}
    struct C2: Component {}
    struct C3: Component {}
    struct C4: Component {}
    struct C5: Component {}
    
    let components: [Component.Type] = [
        C1.self,
        C2.self,
        C3.self,
        C4.self,
        C5.self,
    ]
    
    private var chunkStore: ChunkStore!
    
    override func setUp() {
        let store = ChunkStore(
            components: components,
            chunkSize: 5
        )
        self.chunkStore = store
    }
    
    func testInitialization() {
        XCTAssertEqual(0, chunkStore._entitiesCount)
        XCTAssertEqual(0, chunkStore._chunksCount)
        XCTAssertEqual(5, chunkStore._typeMapCount)
        XCTAssertEqual(5, chunkStore._orderMapCount)
    }
    
    func testAddEntitiesOfSameArchetype() {
        try! _ = chunkStore.append([C1(), C2()])
        try! _ = chunkStore.append([C1(), C2()])
        XCTAssertEqual(2, chunkStore._entitiesCount)
        XCTAssertEqual(1, chunkStore._chunksCount)
    }
    
    func testAddEntitiesOfSameArchetypeWithComponentOrder() {
        try! _ = chunkStore.append([C1(), C2(), C3(), C4()])
        try! _ = chunkStore.append([C2(), C1(), C4(), C3()])
        XCTAssertEqual(2, chunkStore._entitiesCount)
        XCTAssertEqual(1, chunkStore._chunksCount)
    }
    
    func testAddEntitiesOfDifferentArchetypes() {
        try! _ = chunkStore.append([C1(), C2()])
        try! _ = chunkStore.append([C1(), C3()])
        try! _ = chunkStore.append([C4(), C3()])
        XCTAssertEqual(3, chunkStore._entitiesCount)
        XCTAssertEqual(3, chunkStore._chunksCount)
    }
    
    func testAddEntitiesOfSameArchetypeIntoDifferentChunks() {
        for _ in 0...chunkStore._chunkSize {
            try! _ = chunkStore.append([C1(), C2(), C3(), C4()])
        }
        XCTAssertEqual(chunkStore._chunkSize + 1, chunkStore._entitiesCount)
        XCTAssertEqual(2, chunkStore._chunksCount)
    }
}
