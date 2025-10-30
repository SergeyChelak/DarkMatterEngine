//
//  Component.swift
//  DarkMatterECS
//
//  Created by Sergey on 29.10.2025.
//

import Foundation

public typealias ComponentIdentifier = ObjectIdentifier

public protocol Component: Codable, Sendable {
    var componentId: ComponentIdentifier { get }
}

extension Component {
    var componentId: ComponentIdentifier {
        ComponentIdentifier(Self.self)
    }
}
