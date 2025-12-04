//
//  ButtonState.swift
//  DarkMatterWorld
//
//  Created by Sergey on 04.12.2025.
//


public enum ButtonState: Sendable {
    case justReleased,
         released,
         justPressed,
         pressed
    
    public func toggle(isPressed: Bool) -> Self {
        switch (isPressed, self) {
        case (true, .released): .justPressed
        case (true, .justPressed): .pressed
        case (false, .pressed): .justReleased
        case (false, .justReleased): .released
        default: self
        }
    }
    
    static let `default`: Self = .released
}
