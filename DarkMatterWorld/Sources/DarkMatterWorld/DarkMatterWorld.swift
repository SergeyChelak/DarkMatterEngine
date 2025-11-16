import Foundation

final class DarkMatterWorld {
    // TODO: implement
}

public struct EntityId: Hashable, Codable, Equatable, Sendable {
    let id: StableIndex
}

public enum DarkMatterError: Error {
    case unknownComponent(ComponentIdentifier)
    case unexpectedComponentType(String)
    case componentAddedMultipleTimes(ComponentIdentifier)
    case archetypeMismatch
    case chunkOverflow
    case entityNotFound(EntityId)
//    case generationMismatch(EntityId)
}
