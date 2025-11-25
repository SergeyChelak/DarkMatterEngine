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
        clearColor: .init(),
        preferredFramesPerSecond: 60
    )
}
