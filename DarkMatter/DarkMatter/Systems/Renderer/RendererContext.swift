//
//  RendererContext.swift
//  DarkMatter
//
//  Created by Sergey on 25.11.2025.
//

import MetalKit

final class RendererContext {
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
    return RendererContext(
        device: device,
        commandQueue: commandQueue,
        library: library,
        colorPixelFormat: colorPixelFormat,
        clearColor: clearColor,
        preferredFramesPerSecond: preferredFramesPerSecond,
    )
}
