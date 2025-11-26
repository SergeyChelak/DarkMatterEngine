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
    private let assetManager: AssetManager
    
    private let renderSystem: RendererSystem
    
    init() {
        renderSystem = RendererSystem(metalContext: metalContext)
        
        assetManager = AssetManager(
            metalContext: metalContext,
            pixelFormat: rendererConfig.colorPixelFormat
        )
        assert(assetManager.mockLoadMesh() != nil)
        assert(assetManager.mockLoadMaterial() != nil)
    }
    
    var body: some Scene {
        WindowGroup {
            MetalView(renderSystem, rendererConfig)
//                .onAppear {
//                    NSApplication.shared.windows.forEach {
//                        $0.hideAllElements()
//                    }
//                }
                .onAppear {
                    // simulate one scheduler call
                    let renderable = RenderableComponent(
                        meshID: "msh_1",
                        materialID: "mtrl_1"
                    )
                    renderSystem.process(
                        renderables: [renderable],
                        assetManager: assetManager
                    )
                }
                .onDisappear {
                    Darwin.exit(0)
                }
        }
//        .windowStyle(.hiddenTitleBar)
        .commandsRemoved()
    }
}
