//
//  NSWindow+Styling.swift
//  DarkMatter
//
//  Created by Sergey on 11.11.2025.
//

import Foundation
import AppKit

extension NSWindow {
    func hideAllElements() {
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.lightTrafficButtonsVisible(false)
    }
    
    func lightTrafficButtonsVisible(_ isVisible: Bool) {
        let buttons: [NSWindow.ButtonType] = [
            .closeButton,
            .zoomButton,
            .miniaturizeButton
        ]
        buttons
            .compactMap { standardWindowButton($0) }
            .forEach { $0.isHidden = !isVisible }
    }
}
