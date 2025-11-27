//
//  ViewRepresentable.swift
//  DarkMatter
//
//  Created by Sergey on 28.11.2025.
//

import AppKit
import SwiftUI

struct ViewRepresentable: NSViewRepresentable {
    let view: NSView
    
    func makeNSView(context: Context) -> NSView {
        view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // no op
    }
}

extension NSView {
    func viewRepresentable() -> some SwiftUI.View {
        ViewRepresentable(view: self)
    }
}

#Preview {
    ViewRepresentable(view: NSView())
}
