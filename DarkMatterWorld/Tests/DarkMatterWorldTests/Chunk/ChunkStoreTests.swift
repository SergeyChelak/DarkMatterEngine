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
    
    func testGetSetComponentValue() {
        let entity = try! chunkStore.append([
            StringValue(value: "aaa"),
            IntValue(value: 2),
            FloatValue(value: 44.0),
            BoolValue(value: false)
        ])
        
        let _ = try! chunkStore.append([
            StringValue(value: "eee"),
            IntValue(value: 23),
            FloatValue(value: 444.0),
            BoolValue(value: false)
        ])
        
        XCTAssertNil(chunkStore.get(entity, type: Marker.self))
        XCTAssertEqual(chunkStore.get(entity, type: FloatValue.self), FloatValue(value: 44.0))
        XCTAssertEqual(chunkStore.get(entity, type: StringValue.self), StringValue(value: "aaa"))
        XCTAssertEqual(chunkStore.get(entity, type: BoolValue.self), BoolValue(value: false))
     
        // update values
        XCTAssert(chunkStore.set(entity, value: FloatValue(value: 33.0)))
        XCTAssert(chunkStore.set(entity, value: StringValue(value: "bbb")))
        XCTAssert(chunkStore.set(entity, value: BoolValue(value: true)))
        
        XCTAssertNil(chunkStore.get(entity, type: Marker.self))
        XCTAssertEqual(chunkStore.get(entity, type: FloatValue.self), FloatValue(value: 33.0))
        XCTAssertEqual(chunkStore.get(entity, type: StringValue.self), StringValue(value: "bbb"))
        XCTAssertEqual(chunkStore.get(entity, type: BoolValue.self), BoolValue(value: true))

    }
    
    func testAlterAddComponent() {
        let entity1 = try! chunkStore.append([
            StringValue(value: "aaa"),
            IntValue(value: 2),
        ])
        XCTAssertEqual(1, chunkStore._archetypesCount)
        XCTAssertNil(chunkStore.get(entity1, type: FloatValue.self))
        
        try! chunkStore.addComponent(entity1, FloatValue(value: 44.0))
        XCTAssertEqual(2, chunkStore._archetypesCount)
        XCTAssertEqual(chunkStore.get(entity1, type: FloatValue.self), FloatValue(value: 44.0))
    }
    
    func testAlterRemoveComponent() {
        let entity1 = try! chunkStore.append([
            StringValue(value: "aaa"),
            IntValue(value: 2),
            FloatValue(value: 44.0)
        ])
        XCTAssertEqual(1, chunkStore._archetypesCount)
        XCTAssertEqual(chunkStore.get(entity1, type: FloatValue.self), FloatValue(value: 44.0))
        
        try! chunkStore.removeComponent(entity1, FloatValue.self)
        XCTAssertEqual(2, chunkStore._archetypesCount)
        XCTAssertNil(chunkStore.get(entity1, type: FloatValue.self))
    }
    
    func testRemoveEntities() {
        let makeEntity = { () -> [Component] in
            let strOptions = ["AAA", "AA", "A", "ABCDEF"]
            let components: [Component] = [
                Marker(),
                StringValue(value: strOptions.randomElement()!),
                IntValue(value: Int.random(in: 2...50)),
                FloatValue(value: Float.random(in: -1...1)),
            ]
            return components
        }
        
        let entities = (0..<chunkStore._chunkSize)
            .map { _ in
                return try! chunkStore.append(makeEntity())
            }
        XCTAssertEqual(1, chunkStore._archetypesCount)
        XCTAssertEqual(1, chunkStore._chunksCount)

        let first = entities.first!
        XCTAssert(chunkStore.isAlive(first))
        try! chunkStore.remove(first)
        XCTAssertFalse(chunkStore.isAlive(first))
        // can't remove this entity again
        XCTAssertThrowsError(try chunkStore.remove(first))
        
        // check if new entity will be placed instead of old one
        let newEntityComponents = makeEntity()
        let newEntity = try! chunkStore.append(newEntityComponents)
        XCTAssertEqual(1, chunkStore._archetypesCount)
        XCTAssertEqual(1, chunkStore._chunksCount)
        
        
        let str = chunkStore.get(newEntity, type: StringValue.self)
        XCTAssertEqual(
            str,
            newEntityComponents[1] as? StringValue
        )
        
        XCTAssertEqual(
            chunkStore.get(newEntity, type: IntValue.self),
            newEntityComponents[2] as? IntValue
        )
        
        XCTAssertEqual(
            chunkStore.get(newEntity, type: FloatValue.self),
            newEntityComponents[3] as? FloatValue
        )
    }
}
