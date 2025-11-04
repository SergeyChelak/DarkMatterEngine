import Foundation

public protocol DarkMatterWorld: AnyObject, Command {
    //
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
