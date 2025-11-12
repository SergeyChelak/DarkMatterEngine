import XCTest
@testable import DarkMatterWorld

final class DenseArrayTests: XCTestCase {
    func testCreateEmptyDenseArray() throws {
        let array: DenseArray<Int> = .init()
        XCTAssertTrue(array.isEmpty)
    }
    
    func testCreateDenseArrayFromArray() throws {
        let source = [1, 2, 3, 4, 5]
        let dense = DenseArray(source)
        XCTAssertEqual(dense._array(), source)
    }
    
    func testIterateOverDenseArray() throws {
        let source = [1, 2, 3, 4, 5]
        let dense = DenseArray(source)
        XCTAssertTrue(zip(source, dense).allSatisfy { $0 == $1 })
    }

    func testDenseArrayReadByIndex() throws {
        let source = [1, 2, 3, 4, 5]
        let dense = DenseArray(source)
        for i in 0..<dense.count {
            XCTAssertEqual(source[i], dense[i])
        }
    }
    
    func testDenseArrayWriteByIndex() throws {
        let source = [1, 2, 3, 4, 5]
        var dense = DenseArray(source)
        for i in 0..<dense.count {
            dense[i] *= 2
        }
        for i in 0..<dense.count {
            XCTAssertEqual(2 * source[i], dense[i])
        }
    }
    
    func testAppendToDenseArray() throws {
        let source = [1, 2, 3, 4, 5]
        var dense: DenseArray<Int> = .init()
        source
            .enumerated()
            .forEach { (i, val) in
                dense.append(val)
                XCTAssertEqual(i + 1, dense.count)
            }
        XCTAssertEqual(dense._array(), source)
    }
    
    func testCleanDenseArray() throws {
        let source = [1, 2, 3, 4, 5]
        var dense = DenseArray(source)
        while !dense.isEmpty {
            dense.remove(at: 0)
        }
    }
    
    func testDeleteFromDenseArray() throws {
        let source = [1, 2, 3, 4, 5]
        var dense = DenseArray(source)
        let val = dense.remove(at: 2)
        XCTAssertEqual(val, 3)
        XCTAssertEqual(dense[2], 5)
        XCTAssertEqual(dense.count, source.count - 1)
        XCTAssertEqual(dense._totalCount, source.count)
    }
    
    func testDeleteAndAppendToDenseArray() throws {
        let source = [1, 2, 3, 4, 5]
        var dense = DenseArray(source)
        dense.remove(at: 2)
        dense.append(3)
        XCTAssertEqual(dense.count, source.count)
        // new memory didn't allocate
        XCTAssertEqual(dense._totalCount, source.count)
        XCTAssertEqual(dense._array(), [1, 2, 5, 4, 3])
    }
}
