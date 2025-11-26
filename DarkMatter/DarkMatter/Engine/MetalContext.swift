//
//  MetalContext.swift
//  DarkMatter
//
//  Created by Sergey on 25.11.2025.
//

import Foundation
import MetalKit

final class MetalContext {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let library: MTLLibrary
    
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

enum MetalContextError: Error {
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
