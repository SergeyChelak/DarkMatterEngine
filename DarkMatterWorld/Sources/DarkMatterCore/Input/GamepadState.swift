//
//  GamepadState.swift
//  DarkMatterWorld
//
//  Created by Sergey on 03.12.2025.
//

import Foundation

public struct GamepadState {
    public let menu: ButtonState = .default
    public let home: ButtonState = .default
    public let options: ButtonState = .default
    
    /**
     Diamond buttons
    */
    public let A: ButtonState = .default
    public let B: ButtonState = .default
    public let X: ButtonState = .default
    public let Y: ButtonState = .default    
}
