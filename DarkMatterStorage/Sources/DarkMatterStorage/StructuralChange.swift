//
//  StructuralChange.swift
//  DarkMatterStorage
//
//  Created by Sergey on 31.10.2025.
//

import Foundation

typealias StructuralChangeResult<T> = Result<T, StorageError>

struct UpdatedArrayPosition {
    let previous: Int
    let current: Int
}

struct EntityPosition {
    let entityId: EntityId
    let position: Int
}
