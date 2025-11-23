//
//  ChunkShared.swift
//  DarkMatterWorld
//
//  Created by Sergey on 23.11.2025.
//

@testable import DarkMatterWorld

final class ChunkShared {
    struct FloatValue: Component, Equatable {
        let value: Float
    }
    
    struct IntValue: Component, Equatable {
        let value: Int
    }
    
    struct BoolValue: Component, Equatable {
        let value: Bool
    }
    
    struct StringValue: Component, Equatable {
        let value: String
    }    
}
