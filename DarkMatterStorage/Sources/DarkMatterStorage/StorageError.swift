//
//  StorageError.swift
//  DarkMatterStorage
//
//  Created by Sergey on 31.10.2025.
//

import Foundation

public enum StorageError: Error {
    case invalidArchetype
    case indexOutOfBound(_ index: Int, _ size: Int)
    case invalidComponentType
}
