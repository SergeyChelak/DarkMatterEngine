//
//  MetalRenderer.swift
//  DarkMatter
//
//  Created by Sergey on 27.11.2025.
//

import MetalKit

protocol MetalRenderer {
    var device: MTLDevice { get }
    
    func render(
        drawable: CAMetalDrawable,
        renderPassDescriptor: MTLRenderPassDescriptor
    )
}
