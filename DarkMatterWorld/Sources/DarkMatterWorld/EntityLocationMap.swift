//
//  EntityLocationMap.swift
//  DarkMatterWorld
//
//  Created by Sergey on 16.11.2025.
//


final class EntityLocationMap {
    // One-to-one relationships are expected between entity and its location
    private var entityToLocation: GenerationalArray<EntityLocation> = .init()
    private var locationToEntity: [EntityLocation: EntityId] = [:]
    
    func append(_ location: EntityLocation) -> EntityId {
        let index = entityToLocation.append(location)
        let entityId = EntityId(id: index)
        locationToEntity[location] = entityId
        return entityId
    }
    
    func remove(at index: StableIndex) -> EntityLocation? {
        guard let location = entityToLocation.get(at: index) else {
            return nil
        }
        locationToEntity.removeValue(forKey: location)
        entityToLocation.remove(at: index)
        return location
    }
    
    func remove(_ location: EntityLocation) -> StableIndex? {
        guard let entityId = locationToEntity[location] else {
            return nil
        }
        locationToEntity.removeValue(forKey: location)
        entityToLocation.remove(at: entityId.id)
        return entityId.id
    }
}
