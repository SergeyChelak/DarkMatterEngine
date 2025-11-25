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

    private let rendererContext: RendererContext
    
    init(_ rendererContext: RendererContext) {
        self.rendererContext = rendererContext
    }
    
    func makeCoordinator() -> Coordinator {
        Renderer(rendererContext)
    }
    
    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = rendererContext.device
        view.colorPixelFormat = rendererContext.colorPixelFormat
        view.clearColor = rendererContext.clearColor
        view.preferredFramesPerSecond = rendererContext.preferredFramesPerSecond
        view.enableSetNeedsDisplay = true
        view.delegate = context.coordinator
        return view
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        // no op
    }
}

#Preview {
    MetalView(try! makeRendererContext())
}
