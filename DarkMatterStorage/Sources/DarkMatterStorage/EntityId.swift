//
//  EntityId.swift
//  DarkMatterStorage
//
//  Created by Sergey on 31.10.2025.
//

import Foundation

public struct EntityId: Hashable, Codable, Equatable {
    public let id: Int
    public let generation: UInt64
}
