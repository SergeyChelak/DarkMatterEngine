//
//  ChunkStoreTests.swift
//  DarkMatterWorld
//
//  Created by Sergey on 17.11.2025.
//

import XCTest
@testable import DarkMatterWorld

final class ChunkStoreTests: XCTestCase {
    typealias FloatValue = ChunkShared.FloatValue
    typealias IntValue = ChunkShared.IntValue
    typealias BoolValue = ChunkShared.BoolValue
    typealias StringValue = ChunkShared.StringValue
    
    struct Marker: Component {}
    
    let components: [Component.Type] = [
        FloatValue.self,
        IntValue.self,
        BoolValue.self,
        StringValue.self,
        Marker.self,
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
        try! _ = chunkStore.append([FloatValue(value: 1.0), Marker()])
        try! _ = chunkStore.append([FloatValue(value: 1.5), Marker()])
        XCTAssertEqual(2, chunkStore._entitiesCount)
        XCTAssertEqual(1, chunkStore._chunksCount)
    }
    
    func testAddEntitiesOfSameArchetypeWithComponentOrder() {
        let first: [Component] = [
            FloatValue(value: 0.5),
            IntValue(value: 2),
            StringValue(value: "aaa"),
            Marker()
        ]
        
        let second: [Component] = [
            IntValue(value: 5),
            FloatValue(value: 1.5),
            Marker(),
            StringValue(value: "BBB")
        ]
        
        try! _ = chunkStore.append(first)
        try! _ = chunkStore.append(second)
        XCTAssertEqual(2, chunkStore._entitiesCount)
        XCTAssertEqual(1, chunkStore._chunksCount)
    }
    
    func testAddEntitiesOfDifferentArchetypes() {
        try! _ = chunkStore.append([
            Marker(),
            StringValue(value: "aaa"),
        ])
        try! _ = chunkStore.append([
            Marker(),
            IntValue(value: 2),
        ])
        try! _ = chunkStore.append([
            FloatValue(value: 1.5),
            IntValue(value: 4),
        ])
        XCTAssertEqual(3, chunkStore._entitiesCount)
        XCTAssertEqual(3, chunkStore._chunksCount)
    }
    
    func testAddEntitiesOfSameArchetypeIntoDifferentChunks() {
        let strOptions = ["AAA", "AA", "A", "ABCDEF"]
        
        for _ in 0...chunkStore._chunkSize {
            let components: [Component] = [
                Marker(),
                StringValue(value: strOptions.randomElement()!),
                IntValue(value: Int.random(in: 2...50)),
                FloatValue(value: Float.random(in: -1...1)),
            ]
            try! _ = chunkStore.append(components)
        }
        XCTAssertEqual(chunkStore._chunkSize + 1, chunkStore._entitiesCount)
        XCTAssertEqual(2, chunkStore._chunksCount)
    }
}
