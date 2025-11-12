import XCTest
@testable import DarkMatterWorld

final class GenerationalArrayTests: XCTestCase {
    // MARK: - Initialization and Basic State

    func testInitialization() {
        let array = GenerationalArray<Int>()
        XCTAssertEqual(array.count, 0, "Count should be zero on initialization.")
        XCTAssertTrue(array.isEmpty, "Array should be empty on initialization.")
        XCTAssertEqual(array.totalCount, 0, "Total size should be zero on initialization.")
    }

    // MARK: - Insertion and Retrieval

    func testAppendAndSubscript() {
        var array = GenerationalArray<String>()
        
        let indexA = array.append("Apple")
        let indexB = array.append("Banana")
        
        XCTAssertEqual(array.count, 2, "Count should reflect appended items.")
        XCTAssertEqual(array[indexA], "Apple")
        XCTAssertEqual(array[indexB], "Banana")
        
        // Check initial generations (should be 0)
        XCTAssertEqual(indexA.generation, 0)
        XCTAssertEqual(indexB.generation, 0)
    }

    // MARK: - Removal and Generation Logic

    func testRemoveValidElement() {
        var array = GenerationalArray<Int>()
        let index = array.append(100)
        XCTAssertEqual(array.count, 1)
        let removedValue = array.remove(at: index)
        
        XCTAssertEqual(removedValue, 100)
        XCTAssertEqual(array.count, 0, "Count should decrease after removal.")
        XCTAssertNil(array[index], "Subscript access with the old index should fail.")
        
        // Check that the slot is now marked as empty and generation is incremented
        let currentElementGeneration = array._generation(at: index.slot)
        XCTAssertEqual(currentElementGeneration, index.generation &+ 1)
    }

    func testRemoveInvalidIndex() {
        var array = GenerationalArray<Int>()
        let indexA = array.append(1)
        
        // Create a fake index with a wrong generation
        let invalidIndex = StableIndex(
            slot: indexA.slot,
            generation: indexA.generation + 1
        )
        
        let removedValue = array.remove(at: invalidIndex)
        
        XCTAssertNil(removedValue, "Should return nil when generation doesn't match.")
        XCTAssertEqual(array.count, 1, "Count should remain unchanged.")
        XCTAssertEqual(array[indexA], 1, "The original element should still be present.")
    }

    // MARK: - Recycling Logic (Append after Removal)

    func testRecyclingSlots() {
        var array = GenerationalArray<Int>()
        
        let indexA = array.append(1)
        let indexB = array.append(2)
        
        // Remove A (Slot 0 is now recycled, generation is 1)
        _ = array.remove(at: indexA)
        
        // Append C (should use recycled Slot 0)
        let indexC = array.append(3) // Should use slot 0
        
        XCTAssertEqual(indexC.slot, indexA.slot, "Index C should reuse slot 0.")
        XCTAssertEqual(indexC.generation, indexA.generation &+ 1, "Index C's generation should be incremented.")
        
        // Test stability: The original indexA should be invalid
        XCTAssertNil(array[indexA], "Original Index A should be invalid.")
        XCTAssertEqual(array[indexC], 3, "New Index C should access the new value.")
        XCTAssertEqual(array[indexB], 2, "Index B should remain valid.")
    }
    
    // MARK: - Iterator / Sequence Conformance

    func testIterator() {
        var array = GenerationalArray<Int>()
        
        array.append(10)
        let indexB = array.append(20)
        array.append(30)
        
        // Remove a middle element to ensure the iterator skips empty slots
        array.remove(at: indexB)
        
        let expectedElements = [10, 30]
        var actualElements = [Int]()
        
        for element in array {
            actualElements.append(element)
        }
        
        XCTAssertEqual(actualElements.count, array.count, "Iterator should yield the correct number of items.")
        XCTAssertEqual(actualElements, expectedElements, "Iterator should skip removed elements.")
    }
    
    func testIteratorWithAllRemoved() {
        var array = GenerationalArray<String>()
        let indexA = array.append("X")
        let indexB = array.append("Y")
        
        array.remove(at: indexA)
        array.remove(at: indexB)
        
        var count = 0
        for _ in array {
            count += 1
        }
        
        XCTAssertEqual(count, 0, "Iterator should yield zero items when array is empty.")
    }
}
