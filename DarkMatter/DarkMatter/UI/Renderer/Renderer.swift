//
//  Renderer.swift
//  DarkMatter
//
//  Created by Sergey on 24.11.2025.
//

import Foundation
import MetalKit

typealias Float3 = SIMD3<Float>

final class Renderer: NSObject {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let renderPipelineState: MTLRenderPipelineState?
    
    private let vertexBuffer: MTLBuffer?
    
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
        
        vertexBuffer = device.makeBuffer(
            bytes: vertices,
            length: MemoryLayout<Float3>.stride * vertices.count,
            options: []
        )

        super.init()
    }
    
    let vertices: [Float3] = [
        Float3( 0,  1,  0),
        Float3(-1, -1,  0),
        Float3( 1, -1,  0)
    ]
    
    // TODO: refactor
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
              let vertexBuffer,
              let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }
        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        renderCommandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
