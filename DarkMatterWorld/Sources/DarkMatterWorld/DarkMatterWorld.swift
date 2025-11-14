import Foundation

public protocol DarkMatterWorld: AnyObject {
    //
}

public struct EntityId: Hashable, Codable, Equatable, Sendable {
    let id: StableIndex
}

public enum DarkMatterError: Error {
    case unknownComponent(Component)
    case unexpectedComponentType(String)
    case componentAddedMultipleTimes(Component)
    case archetypeMismatch
    case chunkOverflow
}
