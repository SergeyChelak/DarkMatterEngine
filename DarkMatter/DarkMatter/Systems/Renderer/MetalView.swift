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

    let environment: RendererEnvironment
    
    init(_ environment: RendererEnvironment) {
        self.environment = environment
    }
            
    func makeCoordinator() -> Coordinator {
        Renderer(environment)
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

extension MetalView: RendererEnvironmentAccessors { }

#Preview {
    MetalView(try! makeStandardRenderEnvironment())
}
