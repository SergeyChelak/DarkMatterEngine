//
//  Renderer.swift
//  DarkMatter
//
//  Created by Sergey on 24.11.2025.
//

import Foundation
import MetalKit

final class Renderer: NSObject {
    private let metal: MetalContext
    private let config: RendererConfiguration
    
    private var gameObjects: [Renderable] = []
    
    init(
        _ metal: MetalContext,
        _ config: RendererConfiguration
    ) {
        self.metal = metal
        self.config = config

        // ---
        if let obj: GameObject = .with(metal, config) {
            gameObjects.append(obj)
        }
        // ---
        super.init()
    }    
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // TODO: update aspect ratio
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandBuffer = metal.commandQueue.makeCommandBuffer() else {
            return
        }
        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        for obj in gameObjects {
            obj.render(renderCommandEncoder)
        }
        
        renderCommandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
