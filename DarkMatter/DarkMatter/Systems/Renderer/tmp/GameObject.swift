//
//  GameObject.swift
//  DarkMatter
//
//  Created by Sergey on 25.11.2025.
//

import MetalKit

class GameObject {
    private let vertexBuffer: MTLBuffer
    private let renderPipelineState: MTLRenderPipelineState
    private let vertices: [Vertex]
    
    init(
        vertexBuffer: MTLBuffer,
        renderPipelineState: MTLRenderPipelineState,
        vertices: [Vertex],
    ) {
        self.vertexBuffer = vertexBuffer
        self.renderPipelineState = renderPipelineState
        self.vertices = vertices
    }
    
    static func with(
        _ metalContext: MetalContext,
        _ config: RendererConfiguration,
    ) -> GameObject? {
        let vertices: [Vertex] = [
            Vertex(position: Vec3f( 0,  1,  0), color: Vec4f(1,0,0,1)),
            Vertex(position: Vec3f(-1, -1,  0), color: Vec4f(0,1,0,1)),
            Vertex(position: Vec3f( 1, -1,  0), color: Vec4f(0,0,1,1))
        ]
        
        guard let vertexBuffer = metalContext.device.makeBuffer(
            bytes: vertices,
            length: Vertex.stride * vertices.count,
            options: []
        ) else {
            return nil
        }
        
        guard let renderPipelineState = createRenderPipelineState(
            metalContext: metalContext,
            config: config,
            for: Vertex.self,
            vertexFunctionName: "basicVertexShader",
            fragmentFunctionName: "basicFragmentShader"
        ) else {
            return nil
        }
        
        return GameObject(
            vertexBuffer: vertexBuffer,
            renderPipelineState: renderPipelineState,
            vertices: vertices
        )
    }
}

// TODO: refactor
func createRenderPipelineState<T: VertexLayout>(
    metalContext: MetalContext,
    config: RendererConfiguration,
    for type: T.Type,
    vertexFunctionName: String,
    fragmentFunctionName: String,
) -> MTLRenderPipelineState? {
    let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
    renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = config.colorPixelFormat
    
    let vertexFunction = metalContext.library.makeFunction(name: vertexFunctionName)
    renderPipelineStateDescriptor.vertexFunction = vertexFunction
    
    let fragmentFunction = metalContext.library.makeFunction(name: fragmentFunctionName)
    renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
    
    renderPipelineStateDescriptor.vertexDescriptor = type.vertexDescriptor
    
    return try? metalContext.device.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
}

extension GameObject: Renderable {
    func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    }
}
