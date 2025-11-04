//
//  Command.swift
//  DarkMatterWorld
//
//  Created by Sergey on 05.11.2025.
//

import Foundation

public protocol Command:
    EntityCommand,
    ResourceCommand,
    StateCommand {
    // extra methods
}
