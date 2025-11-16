import XCTest
@testable import DarkMatterWorld

final class ComponentMappingTests: XCTestCase {
    struct C1: Component {}
    struct C2: Component {}
    struct C3: Component {}
    struct C4: Component {}
    struct C5: Component {}
    
    func testUniqueComponentOrderMap() throws {
        let components: [Component.Type] = [
            C1.self,
            C2.self,
            C3.self,
            C4.self,
            C5.self,
        ]
        
        let map: ComponentOrderMap = .with(components)
        for (i, c) in components.enumerated() {
            XCTAssertEqual(i, map[c.componentId])
        }
    }
    
    func testComponentOrderMapUniqueIdentifiers() throws {
        let components: [Component.Type] = [
            C1.self,
            C2.self,
            C3.self,
            C5.self,
            C4.self,
            C4.self,
            C5.self,
            C1.self
        ]
        
        let map: ComponentOrderMap = .with(components)
        XCTAssertEqual(5, map.values.count)
    }
}
