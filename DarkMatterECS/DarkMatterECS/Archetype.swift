//
//  Archetype.swift
//  DarkMatterECS
//
//  Created by Sergey on 29.10.2025.
//

import Foundation

public typealias ArchetypeKey = Set<ComponentIdentifier>

extension ArchetypeKey {
    static func with(_ components: [Component]) -> Self {
        var value = ArchetypeKey()
        components.forEach {
            value.insert($0.componentId)
        }
        return value
    }
}


public struct IndexChange {
    let old: Int
    let new: Int
}

public struct Archetype {
    typealias RemoveCallback = (IndexChange) -> Void
    
    func remove(_ index: Int, callback: RemoveCallback) {
        //
    }
}
