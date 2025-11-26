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
    
    private let rendererSystem: RendererSystem
    
    init(
        _ rendererSystem: RendererSystem,
        _ config: RendererConfiguration,
    ) {
        self.rendererSystem = rendererSystem
        self.config = config
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(rendererSystem)
    }
    
    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = rendererSystem.device
        view.colorPixelFormat = config.colorPixelFormat
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
        let renderSystem: RendererSystem
        init(_ renderSystem: RendererSystem) {
            self.renderSystem = renderSystem
        }
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let renderPassDescriptor = view.currentRenderPassDescriptor else {
                return
            }
            renderSystem.render(
                drawable: drawable,
                renderPassDescriptor: renderPassDescriptor
            )
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // TODO: update aspect ratio
        }
    }
}

//#Preview {
//    MetalView(try! makeMetalContext(), .standard)
//}
