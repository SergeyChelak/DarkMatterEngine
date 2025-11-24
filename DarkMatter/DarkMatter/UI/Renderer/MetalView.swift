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
    private let colorPixelFormat: MTLPixelFormat
    
    init(
        device: MTLDevice,
        commandQueue: MTLCommandQueue,
        preferredFramesPerSecond: Int = 60,
        colorPixelFormat: MTLPixelFormat = .bgra8Unorm
    ) {
        self.device = device
        self.commandQueue = commandQueue
        self.preferredFramesPerSecond = preferredFramesPerSecond
        self.colorPixelFormat = colorPixelFormat
    }
    
    func makeCoordinator() -> Coordinator {
        Renderer(
            device: device,
            commandQueue: commandQueue,
            colorPixelFormat: colorPixelFormat
        )
    }
    
    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = device
        // TODO: parametrize
        view.colorPixelFormat = colorPixelFormat
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
