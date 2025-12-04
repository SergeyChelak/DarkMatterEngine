//
//  ControllerInput.swift
//  DarkMatterWorld
//
//  Created by Sergey on 04.12.2025.
//

import GameController

final class ControllerInput {
    typealias ControllerState = NSObject
    
    private var state: ControllerState
    
    init() {
        state = ControllerState()
    }
    
    func onBecameActive(_ controller: GCController) {
        if let extendedGamepad = controller.extendedGamepad {
            setup(extendedGamepad)
            return
        }
        if let microGamepad = controller.microGamepad {
            setup(microGamepad)
            return
        }
    }
    
    func onDisconnect(_ controller: GCController) {
        // TODO: remove handlers...
    }
    
    private func setup(_ extendedGamepad: GCExtendedGamepad) {
        // TODO: ...
    }
    
    private func setup(_ microGamepad: GCMicroGamepad) {
        // TODO: ...
    }

}
