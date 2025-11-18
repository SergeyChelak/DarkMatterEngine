//
//  ChunkTests.swift
//  DarkMatterWorld
//
//  Created by Sergey on 17.11.2025.
//


import XCTest
@testable import DarkMatterWorld

final class ChunkTests: XCTestCase {
    struct FloatValue: Component, Equatable {
        let value: Float
    }

    struct IntValue: Component, Equatable {
        let value: Int
    }

    struct BoolValue: Component, Equatable {
        let value: Bool
    }

    struct StringValue: Component, Equatable {
        let value: String
    }
    
    struct UndefinedComponent: Component { }
    
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
    
    func testInitializationWithUnexpectedComponents() {
        let unexpected = [UndefinedComponent.self] as [Component.Type] + Self.allTypes
        XCTAssertThrowsError(try unexpected
            .map { $0.componentId }
            .canonize(Self.orderMap)
        )
        XCTAssertThrowsError(
            try Chunk(
                identifiers: FinalArray(unexpected.map { $0.componentId }),
                count: Self.capacity,
                typeMap: Self.typeMap
            )
        )
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
    
    func testAppendValidEntityMixedOrder() {
        let entity: [Component] = [
            IntValue(value: 2),
            FloatValue(value: 1.0),
            StringValue(value: "hi"),
            BoolValue(value: true),
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
        let addEntity = { [unowned self] (index: Int) throws -> () in
            let entity: [Component] = [
                FloatValue(value: 1.0),
                IntValue(value: 2),
                BoolValue(value: true),
                StringValue(value: "hi")
            ]
            let entityId: EntityId = .with(index)
            let canonized = try entity.canonize(Self.orderMap)
            _ = try self.chunk.append(entityId, canonized)
        }
        var counter = 0
        while chunk.hasFreeSlots {
            try! addEntity(counter)
            counter += 1
        }
        XCTAssertFalse(chunk.hasFreeSlots)
        XCTAssertEqual(chunk.count, chunk._size)
        XCTAssertThrowsError(try addEntity(counter + 1))
    }
    
    func testRemoveAllElement() {
        for _ in 0...3 {
            for i in 0..<Self.capacity {
                let entity: [Component] = [
                    FloatValue(value: 1.0),
                    IntValue(value: 2),
                    BoolValue(value: true),
                    StringValue(value: "hi")
                ]
                let entityId: EntityId = .with(i)
                let canonized = try! entity.canonize(Self.orderMap)
                _ = try! self.chunk.append(entityId, canonized)
            }
            XCTAssertEqual(Self.capacity, chunk.count)
            XCTAssertEqual(Self.capacity, chunk._entitiesCount)
            
            for _ in 0..<Self.capacity {
                chunk.remove(at: 0)
            }
            
            XCTAssertEqual(0, chunk.count)
            XCTAssertEqual(0, chunk._entitiesCount)
        }
    }
    
    func testDenseRemove() {
        let entity1: [Component] = [
            FloatValue(value: 1.0),
            IntValue(value: 1),
            BoolValue(value: true),
            StringValue(value: "ALL 1")
        ]
        let entity2: [Component] = [
            FloatValue(value: 2.0),
            IntValue(value: 2),
            BoolValue(value: true),
            StringValue(value: "ALL 2")
        ]
        let entity3: [Component] = [
            FloatValue(value: 3.0),
            IntValue(value: 3),
            BoolValue(value: true),
            StringValue(value: "ALL 3")
        ]
        [entity1, entity2, entity3].enumerated()
            .forEach { i, e in
            let entityId: EntityId = .with(i)
            let canonized = try! e.canonize(Self.orderMap)
            _ = try! self.chunk.append(entityId, canonized)
        }
        XCTAssertEqual(3, chunk.count)
        XCTAssertEqual(3, chunk._entitiesCount)
        
        let idxToRemove = 1
        let expectedAffectIdx = chunk.count - 1
        let affectedEntity = chunk.remove(at: idxToRemove)
        XCTAssertEqual(affectedEntity, .with(expectedAffectIdx))
        
        let relocatedComponents = chunk.getAllComponents(at: idxToRemove)
        XCTAssertEqual(relocatedComponents.count, entity3.count)
        for (l, r) in zip(relocatedComponents, entity3) {
            XCTAssert(structuralEqual(l, r))
        }
    }
    
    func testAccessorMethods() {
        let entity1: [Component] = [
            FloatValue(value: 1.0),
            IntValue(value: 1),
            BoolValue(value: true),
            StringValue(value: "ALL 1")
        ]
        let entity2: [Component] = [
            FloatValue(value: 2.0),
            IntValue(value: 2),
            BoolValue(value: true),
            StringValue(value: "ALL 2")
        ]
        let entity3: [Component] = [
            FloatValue(value: 3.0),
            IntValue(value: 3),
            BoolValue(value: true),
            StringValue(value: "ALL 3")
        ]
        let entities = [entity1, entity2, entity3]
        entities.enumerated()
            .forEach { i, e in
            let entityId: EntityId = .with(i)
            let canonized = try! e.canonize(Self.orderMap)
            _ = try! self.chunk.append(entityId, canonized)
        }
        // check each component value
        for i in 0..<chunk.count {
            XCTAssertEqual((entities[i][0] as! FloatValue).value, chunk.get(at: i, FloatValue.self)!.value)
            XCTAssertEqual((entities[i][1] as! IntValue).value, chunk.get(at: i, IntValue.self)!.value)
            XCTAssertEqual((entities[i][2] as! BoolValue).value, chunk.get(at: i, BoolValue.self)!.value)
            XCTAssertEqual((entities[i][3] as! StringValue).value, chunk.get(at: i, StringValue.self)!.value)
            XCTAssertNil(chunk.get(at: i, UndefinedComponent.self))
        }
        
        // update components
        for i in 0..<chunk.count {
            let ref = 2 * (i + 1)
            XCTAssert(chunk.set(at: i, FloatValue(value: Float(ref))))
            XCTAssert(chunk.set(at: i, IntValue(value: ref)))
            XCTAssert(chunk.set(at: i, BoolValue(value: false)))
            XCTAssert(chunk.set(at: i, StringValue(value: "ALL \(ref)")))
            XCTAssertFalse(chunk.set(at: i, UndefinedComponent()))
        }
        
        // check if everything is updated correctly
        for i in 0..<chunk.count {
            let ref = 2 * (i + 1)
            XCTAssertEqual(Float(ref), chunk.get(at: i, FloatValue.self)!.value)
            XCTAssertEqual(ref, chunk.get(at: i, IntValue.self)!.value)
            XCTAssertEqual(false, chunk.get(at: i, BoolValue.self)!.value)
            XCTAssertEqual("ALL \(ref)", chunk.get(at: i, StringValue.self)!.value)
            XCTAssertNil(chunk.get(at: i, UndefinedComponent.self))
        }
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

fileprivate func structuralEqual(_ a: Any, _ b: Any) -> Bool {
    // 1. **Initial Type Check**
    // If they aren't the same type, they cannot be equal.
    let typeA = type(of: a)
    let typeB = type(of: b)
    guard typeA == typeB else {
        return false
    }
    
    // 2. **Reflect the Structure**
    let mirrorA = Mirror(reflecting: a)
    let mirrorB = Mirror(reflecting: b)
    
    // Safety check: Ensure they have the same display style (e.g., struct, class, enum)
    guard mirrorA.displayStyle == mirrorB.displayStyle else {
        return false
    }

    // 4. **Iterate and Compare Properties**
    let propertiesA = mirrorA.children.makeIterator()
    let propertiesB = mirrorB.children.makeIterator()
    
    while let childA = propertiesA.next(), let childB = propertiesB.next() {
        // Ensure property labels (names) are the same, although for same type/order they should be.
        guard childA.label == childB.label else { return false }
        
        // **Recursive Comparison**
        // Since we cannot guarantee the properties are Equatable, we recurse.
        if !structuralEqual(childA.value, childB.value) {
            return false
        }
    }
    
    // Final check: Ensure both mirrors ran out of properties at the same time (same count)
    return propertiesA.next() == nil && propertiesB.next() == nil
}
