//
//  MetalVideoOutput.swift
//  DarkMatterWorld
//
//  Created by Sergey on 03.12.2025.
//

import DarkMatterCore
import MetalKit

final class MetalVideoOutput: NSObject, Video, MTKViewDelegate {
    private let metalContext: MetalContext
    private let rendererConfig: RendererConfiguration
    private var renderer: RenderableSystem?
    
    init(
        metalContext: MetalContext,
        rendererConfig: RendererConfiguration,
    ) {
        self.metalContext = metalContext
        self.rendererConfig = rendererConfig
    }
    
    @MainActor
    private(set) lazy var view: MTKView = {
        let view = MTKView()
        view.device = metalContext.device
        view.colorPixelFormat = rendererConfig.pixelFormat
        view.clearColor = rendererConfig.clearColor
        view.preferredFramesPerSecond = rendererConfig.preferredFramesPerSecond
        view.enableSetNeedsDisplay = true
        view.delegate = self
        return view
    }()
    
    func attach(renderer: RenderableSystem) {
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
