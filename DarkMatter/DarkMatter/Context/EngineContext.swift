//
//  EngineContext.swift
//  DarkMatter
//
//  Created by Sergey on 24.11.2025.
//

import Foundation
import MetalKit

final class EngineContext {
    let device: MTLDevice
    let preferredFramesPerSecond: Int
    let commandQueue: MTLCommandQueue
    
    init(
        device: MTLDevice,
        preferredFramesPerSecond: Int = 60,
        commandQueue: MTLCommandQueue,
    ) {
        self.device = device
        self.commandQueue = commandQueue
        self.preferredFramesPerSecond = preferredFramesPerSecond
    }
}

enum EngineContextError: Error {
    case failedToCreateMetalDevice
}

//#if DEBUG
extension EngineContext {
    static let preview: EngineContext = {
        let device = MTLCreateSystemDefaultDevice()!
        let commandQueue = device.makeCommandQueue()!
        return EngineContext(
            device: device,
            commandQueue: commandQueue
        )
    }()
}
//#endif
