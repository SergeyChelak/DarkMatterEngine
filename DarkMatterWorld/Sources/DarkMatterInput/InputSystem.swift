//
//  File.swift
//  DarkMatterWorld
//
//  Created by Sergey on 04.12.2025.
//

import Combine
import GameController

public protocol Resource {
    //
}

public class InputSystem {
    private var cancellables: Set<AnyCancellable> = []
    
    private let keyboardInput = KeyboardInput()
    private let controllerInput = ControllerInput()
    private let mouseInput = MouseInput()
    
    init() {
        let center = NotificationCenter.default
        
        center.publisher(for: .GCMouseDidConnect)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.mouseDidConnect(notification)
            }
            .store(in: &cancellables)
        
        center.publisher(for: .GCControllerDidBecomeCurrent)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.controllerBecameCurrent(notification)
            }
            .store(in: &cancellables)
    }
        
    private func mouseDidConnect(_ notification: Notification) {
        guard let mouse = notification.object as? GCMouse else {
            return
        }
        mouseInput.onConnect(mouse)
    }
    
    private func controllerBecameCurrent(_ notification: Notification) {
        guard let controller = notification.object as? GCController else {
            return
        }
        controllerInput.onBecameActive(controller)
    }
}
