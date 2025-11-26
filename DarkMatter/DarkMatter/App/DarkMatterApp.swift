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
    private let metalContext = try! makeMetalContext()
    private let rendererConfig: RendererConfiguration = .standard
    
    var body: some Scene {
        WindowGroup {
            MetalView(metalContext, rendererConfig)
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
