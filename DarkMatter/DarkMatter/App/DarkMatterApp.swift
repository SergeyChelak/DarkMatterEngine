//
//  DarkMatterApp.swift
//  DarkMatter
//
//  Created by Sergey on 31.10.2025.
//

import Combine
import MetalKit
import SwiftUI

@main
struct DarkMatterApp: App {
    private let rendererContext = try! makeRendererContext()
    
    var body: some Scene {
        WindowGroup {
            MetalView(rendererContext)
//                .onAppear {
//                    NSApplication.shared.windows.forEach {
//                        $0.hideAllElements()
//                    }
//                }
                .onDisappear {
                    Darwin.exit(0)
                }
        }
//        .windowStyle(.hiddenTitleBar)
        .commandsRemoved()
    }
}
