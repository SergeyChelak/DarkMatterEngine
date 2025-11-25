//
//  Renderer.swift
//  DarkMatter
//
//  Created by Sergey on 24.11.2025.
//

import Foundation
import MetalKit

struct Vertex: Sizable {
    let position: Vec3f
    let color: Vec4f
}

final class Renderer: NSObject {
    private let context: RendererContext

    // TODO: remove temp stuff
    private let renderPipelineState: MTLRenderPipelineState?
    private let vertexBuffer: MTLBuffer?
    
    init(
        _ rendererContext: RendererContext
    ) {
        self.context = rendererContext

        // TODO: fix temporary solution!
        self.renderPipelineState = Self.createRenderPipelineState(context)

        vertexBuffer = rendererContext.device.makeBuffer(
            bytes: vertices,
            length: Vertex.stride * vertices.count,
            options: []
        )

        super.init()
    }
    
    let vertices: [Vertex] = [
        Vertex(position: Vec3f( 0,  1,  0), color: Vec4f(1,0,0,1)),
        Vertex(position: Vec3f(-1, -1,  0), color: Vec4f(0,1,0,1)),
        Vertex(position: Vec3f( 1, -1,  0), color: Vec4f(0,0,1,1))
    ]
    
    // TODO: refactor
    private static func createRenderPipelineState(
        _ context: RendererContext
    ) -> MTLRenderPipelineState? {
        let vertexDescriptor = MTLVertexDescriptor()
        // position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        // color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = Vec3f.stride
        
        vertexDescriptor.layouts[0].stride = Vertex.size
        
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = context.colorPixelFormat
        renderPipelineStateDescriptor.vertexFunction = context.shader(.defaultVertex)
        renderPipelineStateDescriptor.fragmentFunction = context.shader(.defaultFragment)
        renderPipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        
        return try? context.device.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // TODO: update aspect ratio
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let renderPipelineState,
              let vertexBuffer,
              let commandBuffer = context.commandQueue.makeCommandBuffer() else {
            return
        }
        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)

        // ---
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        // ---
        
        renderCommandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
