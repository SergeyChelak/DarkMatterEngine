import Foundation

public protocol DarkMatterWorld: AnyObject {

}

final class World {
    // One-to-one relationships are expected between entity and its location
    private var entityToLocation: GenerationalArray<EntityLocation> = .init()
    private var locationToEntity: [EntityLocation: EntityId] = [:]
    
    private var chunkStore: ChunkStore
    
    init(_ componentTypes: [Component.Type]) {
        chunkStore = ChunkStore(
            components: componentTypes,
            chunkSize: 1000
        )
    }
    
    /// Changes store immediately while `spawn` is deferred operation
    func append(_ components: [Component]) throws -> EntityId {
        let location = try chunkStore
            .append(components)
            .location
        let index = entityToLocation.append(location)
        let entityId = EntityId(id: index)
        locationToEntity[location] = entityId
        return entityId
    }
    
    func remove(_ entityId: EntityId) {
        let index = entityId.id
        guard let location = entityToLocation.get(at: index) else {
            print("Entity not found")
            return
        }
        locationToEntity.removeValue(forKey: location)
        entityToLocation.remove(at: index)
        
        let update = chunkStore.remove(at: location)
        guard let affectedEntity = locationToEntity[update.previous] else {
            fatalError("Affected entity not found. Must be bug in implementation")
        }
        let isOk = entityToLocation.set(at: affectedEntity.id, newValue: update.current)
        assert(isOk, "failed to update affected entity")
        locationToEntity[update.current] = affectedEntity
    }
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
}
