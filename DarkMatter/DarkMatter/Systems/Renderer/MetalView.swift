//
//  MetalView.swift
//  DarkMatter
//
//  Created by Sergey on 23.11.2025.
//

import MetalKit
import SwiftUI

struct MetalView: NSViewRepresentable {
    typealias NSViewType = MTKView
    
    private let config: RendererConfiguration
    private let renderer: MetalRenderer
    
    init(
        _ renderer: MetalRenderer,
        _ config: RendererConfiguration,
    ) {
        self.renderer = renderer
        self.config = config
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(renderer)
    }
    
    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = renderer.device
        view.colorPixelFormat = config.pixelFormat
        view.clearColor = config.clearColor
        view.preferredFramesPerSecond = config.preferredFramesPerSecond
        view.enableSetNeedsDisplay = true
        view.delegate = context.coordinator
        return view
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
        // no op
    }
}


extension MetalView {
    final class Coordinator: NSObject, MTKViewDelegate {
        private let renderer: MetalRenderer
        
        init(_ renderer: MetalRenderer) {
            self.renderer = renderer
        }
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let renderPassDescriptor = view.currentRenderPassDescriptor else {
                return
            }
            renderer.render(
                drawable: drawable,
                renderPassDescriptor: renderPassDescriptor
            )
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // TODO: update aspect ratio
        }
    }
}

#Preview {
    let config: RendererConfiguration = .standard
    return MetalView(
        MockMetalRenderer(pixelFormat: config.pixelFormat),
        config
    )
}

#if DEBUG
final class MockMetalRenderer: MetalRenderer {
    let device = MTLCreateSystemDefaultDevice()!
    private lazy var library: MTLLibrary = {
        device.makeDefaultLibrary()!
    }()
    private lazy var commandQueue: MTLCommandQueue = {
        device.makeCommandQueue()!
    }()
    
    private let pixelFormat: MTLPixelFormat
    
    init(pixelFormat: MTLPixelFormat) {
        self.pixelFormat = pixelFormat
    }
    
    private let vertices: [Vertex] = [
        Vertex(position: Vec3f( 0,  1,  0), color: Vec4f(1,0,0,1)),
        Vertex(position: Vec3f(-1, -1,  0), color: Vec4f(0,1,0,1)),
        Vertex(position: Vec3f( 1, -1,  0), color: Vec4f(0,0,1,1))
    ]
    
    private lazy var vertexBuffer: MTLBuffer = {
        device.makeBuffer(
            bytes: vertices,
            length: Vertex.stride * vertices.count,
            options: []
        )!
    }()
    
    private lazy var pipelineState: MTLRenderPipelineState = {
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        
        let vertexFunction = library.makeFunction(name: "basicVertexShader")
        renderPipelineStateDescriptor.vertexFunction = vertexFunction
        
        let fragmentFunction = library.makeFunction(name: "basicFragmentShader")
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
        
        renderPipelineStateDescriptor.vertexDescriptor = Vertex.vertexDescriptor
        
        return try! device.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
    }()
    
    func render(
        drawable: any CAMetalDrawable,
        renderPassDescriptor: MTLRenderPassDescriptor
    ) {
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderCommandEncoder.setRenderPipelineState(pipelineState)
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(
            type: MTLPrimitiveType.triangle,
            vertexStart: 0,
            vertexCount: vertices.count
        )
        
        renderCommandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
#endif
