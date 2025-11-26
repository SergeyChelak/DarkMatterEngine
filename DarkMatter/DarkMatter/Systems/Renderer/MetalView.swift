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
    typealias Coordinator = Renderer

    private let metal: MetalContext
    private let config: RendererConfiguration
    
    init(
        _ metal: MetalContext,
        _ config: RendererConfiguration
    ) {
        self.metal = metal
        self.config = config
    }
            
    func makeCoordinator() -> Coordinator {
        Renderer(metal, config)
    }
    
    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = metal.device
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

#Preview {
    MetalView(try! makeMetalContext(), .standard)
}
