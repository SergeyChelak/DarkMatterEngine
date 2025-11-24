//
//  Renderer.swift
//  DarkMatter
//
//  Created by Sergey on 24.11.2025.
//

import Foundation
import MetalKit

final class Renderer: NSObject {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let renderPipelineState: MTLRenderPipelineState?
    
    init(
        device: MTLDevice,
        commandQueue: MTLCommandQueue,
        colorPixelFormat: MTLPixelFormat
    ) {
        self.device = device
        self.commandQueue = commandQueue
        // TODO: fix temporary solution!
        self.renderPipelineState = Self.createRenderPipelineState(
            device,
            colorPixelFormat: colorPixelFormat
        )
        super.init()
    }
    
    private static func createRenderPipelineState(
        _ device: MTLDevice,
        colorPixelFormat: MTLPixelFormat
    ) -> MTLRenderPipelineState? {
        guard let library = device.makeDefaultLibrary() else {
            return nil
        }
        let vertexFn = library.makeFunction(name: "basicVertexShader")
        let fragmentFn = library.makeFunction(name: "basicFragmentShader")
        
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        renderPipelineStateDescriptor.vertexFunction = vertexFn
        renderPipelineStateDescriptor.fragmentFunction = fragmentFn
        
        return try? device.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let renderPipelineState,
              let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }
        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        
        // TODO: set data command buffer
        renderCommandEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
