import Foundation

public class WorldStorage {
    //
}

//extension WorldStorage: Command {
//    
//}

public protocol Command: EntityCommand {
    //
}

public protocol Committable {
    func commit<T>() -> T
}
