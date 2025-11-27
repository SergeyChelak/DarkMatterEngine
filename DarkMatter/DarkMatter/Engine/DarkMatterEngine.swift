//
//  DarkMatterEngine.swift
//  DarkMatter
//
//  Created by Sergey on 26.11.2025.
//

import AppKit
import Foundation

protocol GameSystem {
    //
}


final class DarkMatterEngine {
    // system dependencies
    let videoOutput: VideoOutput
    let assetManager: AssetManager
    
    private var systems: [GameSystem] = []
        
    init(
        assetManager: AssetManager,
        videoOutput: VideoOutput
    ) {
        self.assetManager = assetManager
        self.videoOutput = videoOutput
    }
    
    var view: NSView {
        videoOutput.mtkView
    }
    
    func run() {
        // simulate one scheduler call
        let renderable = RenderableComponent(
            meshID: "msh_1",
            materialID: "mtrl_1"
        )
        renderSystem?.process(
            renderables: [renderable],
            assetManager: assetManager
        )
    }
    
    // ---- tmp ---
    var renderSystem: RendererSystem?
    
    func add(system: any GameSystem) {
        systems.append(system)
        if let renderer = system as? Renderer {
            videoOutput.attach(renderer: renderer)
        }
        // --- temp ---
        if let s = system as? RendererSystem {
            videoOutput.attach(renderer: s)
            self.renderSystem = s
        }
    }
}

func makeEngine() -> DarkMatterEngine {
    let metalContext = try! makeMetalContext()
    let rendererConfig: RendererConfiguration = .standard
    
    let renderSystem = RendererSystem(metalContext: metalContext)

    let assetManager = AssetManager(
        metalContext: metalContext,
        pixelFormat: rendererConfig.pixelFormat
    )
    assert(assetManager.mockLoadMesh() != nil)
    assert(assetManager.mockLoadMaterial() != nil)
    
    let videoOutput = MetalVideoOutput(
        metalContext: metalContext,
        rendererConfig: rendererConfig
    )
    
    let engine = DarkMatterEngine(
        assetManager: assetManager,
        videoOutput: videoOutput
    )
    
    engine.add(system: renderSystem)
    
    return engine
}
