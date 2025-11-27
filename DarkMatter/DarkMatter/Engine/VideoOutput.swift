//
//  VideoOutput.swift
//  DarkMatter
//
//  Created by Sergey on 28.11.2025.
//

import MetalKit

protocol Renderer {
    func render(drawable: CAMetalDrawable, renderPassDescriptor: MTLRenderPassDescriptor)
    func drawableSizeWillChange(_ size: CGSize)
}

protocol VideoOutput {
    var mtkView: MTKView { get }
    func attach(renderer: Renderer)
}

final class MetalVideoOutput: NSObject, VideoOutput, MTKViewDelegate {
    private let metalContext: MetalContext
    private let rendererConfig: RendererConfiguration
    private var renderer: Renderer?
    
    init(
        metalContext: MetalContext,
        rendererConfig: RendererConfiguration,
    ) {
        self.metalContext = metalContext
        self.rendererConfig = rendererConfig
    }
    
    @MainActor
    private(set) lazy var mtkView: MTKView = {
        let view = MTKView()
        view.device = metalContext.device
        view.colorPixelFormat = rendererConfig.pixelFormat
        view.clearColor = rendererConfig.clearColor
        view.preferredFramesPerSecond = rendererConfig.preferredFramesPerSecond
        view.enableSetNeedsDisplay = true
        view.delegate = self
        return view
    }()
    
    func attach(renderer: Renderer) {
        self.renderer = renderer
    }
    
    func draw(in view: MTKView) {
        guard let renderer,
              let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        renderer.render(
            drawable: drawable,
            renderPassDescriptor: renderPassDescriptor
        )
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        renderer?.drawableSizeWillChange(size)
    }
}
