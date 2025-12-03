//
//  RendererConfiguration.swift
//  DarkMatterWorld
//
//  Created by Sergey on 03.12.2025.
//

import MetalKit

struct RendererConfiguration {
    let pixelFormat: MTLPixelFormat
    let clearColor: MTLClearColor
    let preferredFramesPerSecond: Int
    
    init(
        pixelFormat: MTLPixelFormat,
        clearColor: MTLClearColor,
        preferredFramesPerSecond: Int
    ) {
        self.pixelFormat = pixelFormat
        self.clearColor = clearColor
        self.preferredFramesPerSecond = preferredFramesPerSecond
    }
    
    static let standard: Self = Self(
        pixelFormat: .bgra8Unorm,
        clearColor: .init(), // MTLClearColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0), 
        preferredFramesPerSecond: 60
    )
}
