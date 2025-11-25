//
//  RendererContext.swift
//  DarkMatter
//
//  Created by Sergey on 25.11.2025.
//

import MetalKit

enum Shader: String {
    case defaultVertex = "basicVertexShader"
    case defaultFragment = "basicFragmentShader"
}

final class RendererContext {
    private var shaders: [String: MTLFunction] = [:]
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let library: MTLLibrary
    let colorPixelFormat: MTLPixelFormat
    let clearColor: MTLClearColor
    let preferredFramesPerSecond: Int
    
    init(
        device: MTLDevice,
        commandQueue: MTLCommandQueue,
        library: MTLLibrary,
        colorPixelFormat: MTLPixelFormat,
        clearColor: MTLClearColor,
        preferredFramesPerSecond: Int
    ) {
        self.device = device
        self.commandQueue = commandQueue
        self.library = library
        self.colorPixelFormat = colorPixelFormat
        self.clearColor = clearColor
        self.preferredFramesPerSecond = preferredFramesPerSecond
    }
    
    @discardableResult
    func registerShader(for name: String, function: String) -> Bool {
        guard let fn = library.makeFunction(name: function) else {
            return false
        }
        fn.label = name
        shaders[name] = fn
        return true
    }
    
    func shader(_ name: String) -> MTLFunction? {
        shaders[name]
    }
    
    @discardableResult
    func registerShader(_ s: Shader) -> Bool {
        registerShader(for: s.rawValue, function: s.rawValue)
    }
    
    func shader(_ s: Shader) -> MTLFunction? {
        shader(s.rawValue)
    }
}

enum RendererError: Error {
    case deviceNotFound
    case commandQueueNotCreated
    case defaultLibraryNotCreated
}

func makeRendererContext(
    colorPixelFormat: MTLPixelFormat = .bgra8Unorm,
    clearColor: MTLClearColor = .init(),
    preferredFramesPerSecond: Int = 60
) throws(RendererError) -> RendererContext {
    guard let device = MTLCreateSystemDefaultDevice() else {
        throw .deviceNotFound
    }
    guard let commandQueue = device.makeCommandQueue() else {
        throw .commandQueueNotCreated
    }
    guard let library = device.makeDefaultLibrary() else {
        throw .defaultLibraryNotCreated
    }
    let context = RendererContext(
        device: device,
        commandQueue: commandQueue,
        library: library,
        colorPixelFormat: colorPixelFormat,
        clearColor: clearColor,
        preferredFramesPerSecond: preferredFramesPerSecond,
    )
    
    assert(context.registerShader(.defaultVertex))
    assert(context.registerShader(.defaultFragment))
    
    return context
}
