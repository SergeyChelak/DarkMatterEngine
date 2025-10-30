//
//  DarkMatterECS.swift
//  DarkMatterECS
//
//  Created by Sergey on 29.10.2025.
//

import Foundation

public struct EntityID: Hashable, Codable {
    let index: Int
    let generation: Int
}

public class Storage {
    // entity map value
    struct EntityMapElement {
        let generation: Int
        let archetypeLocation: Int
        let key: ArchetypeKey
    }
    
    // entity id management
    private var entityMap: [EntityMapElement] = []
    private var removedIndices: [Int] = []

    private var archetypes: [ArchetypeKey: Archetype] = [:]
    
    func nextEntityID() -> EntityID {
        if let index = removedIndices.popLast() {
            return EntityID(
                index: index,
                generation: entityMap[index].generation
            )
        }
        
        
        fatalError()
    }
    
    // MARK: entity management
    public func spawn(with components: Component...) {
        let archetypeKey: ArchetypeKey = .with(components)
        let archetype = self.archetype(for: archetypeKey)
        
        fatalError()
    }
    
    public func kill(entity: EntityID) {
        fatalError()
    }
    
    public func addComponent<T: Component>(to entity: EntityID, component: T) {
        fatalError()
    }
    
    public func removeComponent<T: Component>(from entity: EntityID, ofType: T.Type) {
        fatalError()
    }
    
    // MARK: entity utils
    private func archetype(for key: ArchetypeKey) -> Archetype {
        if let archetype = archetypes[key] {
            return archetype
        }
        // create archetype if not exists
        let value = Archetype()
        archetypes[key] = value
        return value
    }
}
