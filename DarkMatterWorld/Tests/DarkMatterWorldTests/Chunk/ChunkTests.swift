//
//  ChunkTests.swift
//  DarkMatterWorld
//
//  Created by Sergey on 17.11.2025.
//


import XCTest
@testable import DarkMatterWorld

final class ChunkTests: XCTestCase {
    struct FloatValue: Component {
        let value: Float
    }

    struct IntValue: Component {
        let value: Int
    }

    struct BoolValue: Component {
        let value: Bool
    }

    struct StringValue: Component {
        let value: String
    }
    
    static let allTypes: [Component.Type] = [
        FloatValue.self,
        IntValue.self,
        BoolValue.self,
        StringValue.self
    ]

    static let typeMap: ComponentTypeMap = .with(allTypes)
    static let orderMap: ComponentOrderMap = .with(allTypes) { $0.componentId }
    static let capacity: Int = 10
    var chunk: Chunk!
    
    override func setUp() {
        let ids: CanonizedComponentIdentifiers = try! Self.allTypes
            .map { $0.componentId }
            .canonize(Self.orderMap)
        let chunk = try! Chunk(
            identifiers: ids,
            count: Self.capacity,
            typeMap: Self.typeMap
        )
        self.chunk = chunk
    }
    
    func testInitialization() {
        XCTAssertEqual(chunk.count, 0)
        XCTAssertTrue(chunk.hasFreeSlots)
        XCTAssertEqual(Self.allTypes.count, chunk._rowCount)
        XCTAssertEqual(Self.capacity, chunk._size)
    }
    
    func testAppendValidEntity() {
        let entity: [Component] = [
            FloatValue(value: 1.0),
            IntValue(value: 2),
            BoolValue(value: true),
            StringValue(value: "hi")
        ]
        for i in 0..<2 {
            let entityId: EntityId = .with((i + 1) * (i + 2))
            let canonized  = try! entity.canonize(Self.orderMap)
            let index = try! chunk.append(entityId, canonized)
            XCTAssertEqual(index, i)
            XCTAssertEqual(chunk._stableIndex(at: index), entityId.id)
        }
    }
    
    func testAppendInvalidEntity() {
        let entity: [Component] = [
            FloatValue(value: 1.0),
            IntValue(value: 2),
            BoolValue(value: true),
        ]
        let entityId: EntityId = .with(1)
        let canonized  = try! entity.canonize(Self.orderMap)
        XCTAssertThrowsError(try chunk.append(entityId, canonized))
        XCTAssertEqual(chunk.count, 0)
        
        _ = try! chunk.uncheckedAppend(entityId, canonized)
        XCTAssertEqual(chunk.count, 1)
    }
    
    func testFreeSlotsCheck() {
        var counter = 0
        let addEntity = { [unowned self] (index: Int) throws -> () in
            let entity: [Component] = [
                FloatValue(value: 1.0),
                IntValue(value: 2),
                BoolValue(value: true),
                StringValue(value: "hi")
            ]
            let entityId: EntityId = .with(counter)
            counter += 1
            let canonized = try entity.canonize(Self.orderMap)
            _ = try self.chunk.append(entityId, canonized)
        }
        
        while chunk.hasFreeSlots {
            try! addEntity(counter)
            counter += 1
        }
        XCTAssertFalse(chunk.hasFreeSlots)
        XCTAssertEqual(chunk.count, chunk._size)
        XCTAssertThrowsError(try addEntity(counter + 1))
    }
}

fileprivate extension EntityId {
    static func with(_ slot: Int, generation: UInt64 = 0) -> Self {
        let index = StableIndex(
            slot: slot,
            generation: generation
        )
        return EntityId(id: index)
    }
}
