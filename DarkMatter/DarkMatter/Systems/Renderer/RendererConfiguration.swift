//
//  RendererConfiguration.swift
//  DarkMatter
//
//  Created by Sergey on 25.11.2025.
//

import MetalKit

struct RendererConfiguration {
    let colorPixelFormat: MTLPixelFormat
    let clearColor: MTLClearColor
    let preferredFramesPerSecond: Int
    
    init(
        colorPixelFormat: MTLPixelFormat,
        clearColor: MTLClearColor,
        preferredFramesPerSecond: Int
    ) {
        self.colorPixelFormat = colorPixelFormat
        self.clearColor = clearColor
        self.preferredFramesPerSecond = preferredFramesPerSecond
    }
    
    static let standard: Self = Self(
        colorPixelFormat: .bgra8Unorm,
        clearColor: .init(), // MTLClearColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0), 
        preferredFramesPerSecond: 60
    )
}
