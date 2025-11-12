//
//  File.swift
//  DarkMatterWorld
//
//  Created by Sergey on 11.11.2025.
//

import Foundation

extension Array {
    static func with(capacity: Int) -> Self {
        var array = Self.init()
        array.reserveCapacity(capacity)
        return array
    }
}
