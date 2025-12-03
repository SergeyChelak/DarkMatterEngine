//
//  MetalContext.swift
//  DarkMatterWorld
//
//  Created by Sergey on 03.12.2025.
//

import Foundation
import MetalKit

final class MetalContext {
    public let device: MTLDevice
    public let commandQueue: MTLCommandQueue
    public let library: MTLLibrary
    
    init(
        device: MTLDevice,
        commandQueue: MTLCommandQueue,
        library: MTLLibrary
    ) {
        self.device = device
        self.commandQueue = commandQueue
        self.library = library
    }
}

public enum MetalContextError: Error {
    case deviceNotFound
    case commandQueueNotCreated
    case defaultLibraryNotCreated
}

func makeMetalContext() throws(MetalContextError) -> MetalContext {
    guard let device = MTLCreateSystemDefaultDevice() else {
        throw .deviceNotFound
    }
    guard let commandQueue = device.makeCommandQueue() else {
        throw .commandQueueNotCreated
    }
    guard let library = device.makeDefaultLibrary() else {
        throw .defaultLibraryNotCreated
    }
    let context = MetalContext(
        device: device,
        commandQueue: commandQueue,
        library: library,
    )
    return context
}
