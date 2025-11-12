//
//  Entity.swift
//  DarkMatterWorld
//
//  Created by Sergey on 01.11.2025.
//

import Foundation

public struct EntityId: Hashable, Codable, Equatable, Sendable {
    let id: StableIndex
}
