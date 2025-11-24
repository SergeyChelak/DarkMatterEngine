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

    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let preferredFramesPerSecond: Int
    
    init(
        device: MTLDevice,
        commandQueue: MTLCommandQueue,
        preferredFramesPerSecond: Int = 60
    ) {
        self.device = device
        self.commandQueue = commandQueue
        self.preferredFramesPerSecond = preferredFramesPerSecond
    }
    
    func makeCoordinator() -> Coordinator {
        Renderer(
            device: device,
            commandQueue: commandQueue
        )
    }
    
    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = device
        // TODO: parametrize
        view.colorPixelFormat = .bgra8Unorm
        view.clearColor = MTLClearColor(red: 0.4, green: 0.8, blue: 0.5, alpha: 1.0)
        
        view.delegate = context.coordinator
        view.preferredFramesPerSecond = preferredFramesPerSecond
        view.enableSetNeedsDisplay = true
        
        
        
        
        return view
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        //
    }
}

#Preview {
    let device = MTLCreateSystemDefaultDevice()!
    let commandQueue = device.makeCommandQueue()!
    return MetalView(
        device: device,
        commandQueue: commandQueue
    )
}
