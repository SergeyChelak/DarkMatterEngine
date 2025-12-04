//
//  KeyboardInput.swift
//  DarkMatterWorld
//
//  Created by Sergey on 04.12.2025.
//

import GameController

public struct KeyboardState: Resource {}

final class KeyboardInput: UserInput<KeyboardState, GCKeyboard> {
    
    init() {
        super.init(
            initialState: KeyboardState(),
            attachNotification: .GCKeyboardDidConnect,
        )
    }
        
    override func onAttach(_ keyboard: GCKeyboard) {
        guard let keyboardInput = keyboard.keyboardInput else {
            return
        }
        keyboardInput.keyChangedHandler = { _, _, keyCode, isPressed in
            print("key code: \(keyCode) is pressed \(isPressed)")
            // TODO: ...
        }
    }
    
    override func onDetach(_ keyboard: GCKeyboard) {
        // TODO: remove handlers...
    }
}
