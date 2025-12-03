//
//  DarkMatterWorld.swift
//  DarkMatterWorld
//
//  Created by Sergey on 16.11.2025.
//

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
    case entityRelocateFailed(EntityId, EntityLocation)
//    case generationMismatch(EntityId)
}
