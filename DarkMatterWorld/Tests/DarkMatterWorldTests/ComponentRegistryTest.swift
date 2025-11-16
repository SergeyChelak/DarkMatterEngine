import XCTest
@testable import DarkMatterWorld

final class ComponentRegistryTest: XCTestCase {
    struct A: Component {
        let val: Int
    }
    
    struct B: Component {
        let val: String
    }
    
    func testInstantiate() throws {
        let registry = ComponentRegistry(components: [A.self, B.self])
        
    }
}
