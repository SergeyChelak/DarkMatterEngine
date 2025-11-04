import Foundation

public protocol DarkMatterWorld: AnyObject, Command {
    /// Provides access to components of specified entity
    /// Access doesn't mean structural modification of storage
    func entity(_ entityId: EntityId) -> EntityProjection
    
//    /// Perform all postponed actions
//    /// Function must be invoked at the frame end
//    func commitFrame()
}

public protocol Committable {
    func commit<T>() -> T
}

//func test() {
//    struct C1: Component {}
//    
//    let world: DarkMatterWorld = {
//        fatalError()
//    }()
//    
//    let someId: EntityId = {
//        fatalError()
//    }()
//    
//    let val = world.entity(someId)
//        .get(C1.self)
//    if val.isSome {
//        print("OK")
//    }
//}
//
//extension Optional {
//    var isSome: Bool {
//        self != nil
//    }
//    
//    var isNone: Bool {
//        !isSome
//    }
//}
