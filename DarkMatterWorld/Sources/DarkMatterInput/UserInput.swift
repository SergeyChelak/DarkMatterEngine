//
//  UserInput.swift
//  DarkMatterWorld
//
//  Created by Sergey on 04.12.2025.
//

import Combine
import Foundation

class UserInput<State: Resource, Controller> {
    private var cancellables: Set<AnyCancellable> = []
    
    private var state: State
    
    init(
        initialState: State,
        attachNotification: Notification.Name,
        detachNotification: Notification.Name? = nil,
    ) {
        self.state = initialState
        
        let center = NotificationCenter.default
        center.publisher(for: attachNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let controller = notification.object as? Controller else {
                    return
                }
                self?.onAttach(controller)
            }
            .store(in: &cancellables)
        if let detachNotification {
            center.publisher(for: detachNotification)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] notification in
                    guard let controller = notification.object as? Controller else {
                        return
                    }
                    self?.onDetach(controller)
                }
                .store(in: &cancellables)
        }
    }
    
    func onAttach(_ controller: Controller) {
        // no op
    }
    
    func onDetach(_ controller: Controller) {
        // no op
    }
    
    func poll() -> State {
        state
    }
}
