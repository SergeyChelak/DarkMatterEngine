//
//  Query.swift
//  DarkMatterWorld
//
//  Created by Sergey on 01.11.2025.
//

import Foundation

public enum ComponentAccess {
    case read, write
}

public enum ComponentPresence {
    case include, exclude
}

public struct QueryElement {
    let component: Component
    let access: ComponentAccess
    let presence: ComponentPresence
}

public typealias QueryBody = [QueryElement]

public protocol Query {
    func with<T: Component>(_ type: T.Type, access: ComponentAccess) -> Self
    
    func without<T: Component>(_ type: T.Type) -> Self
    
    func elements() -> QueryBody
}


public protocol QueryResult: Sequence<EntityProjection> {
    //
}
