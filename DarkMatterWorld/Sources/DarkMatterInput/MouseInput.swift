//
//  MouseInput.swift
//  DarkMatterWorld
//
//  Created by Sergey on 04.12.2025.
//

import GameController

final class MouseInput {
    func onConnect(_ mouse: GCMouse) {
        guard let mouseInput = mouse.mouseInput else {
            return
        }
        mouseInput.mouseMovedHandler = { _, x, y in
            print("mouse x: \(x), y: \(y)")
            // TODO: ...
        }
    }
    
    func onDisconnect(_ mouse: GCMouse) {
        // TODO: remove handlers...
    }
}
