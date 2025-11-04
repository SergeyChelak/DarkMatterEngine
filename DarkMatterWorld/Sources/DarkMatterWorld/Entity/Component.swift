//
//  Component.swift
//  DarkMatterWorld
//
//  Created by Sergey on 01.11.2025.
//

import Foundation

public typealias ComponentIdentifier = ObjectIdentifier

public protocol Component: Codable, Sendable {
    static var componentId: ComponentIdentifier { get }
    
    var componentId: ComponentIdentifier { get }
}

extension Component {
    static var componentId: ComponentIdentifier {
        ComponentIdentifier(Self.self)
    }
    
    var componentId: ComponentIdentifier {
        Self.componentId
    }
}
