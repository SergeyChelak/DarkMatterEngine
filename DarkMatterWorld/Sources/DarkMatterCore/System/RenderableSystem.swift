//
//  RenderableSystem.swift
//  DarkMatterWorld
//
//  Created by Sergey on 03.12.2025.
//

import MetalKit

public protocol RenderableSystem {
    func render(drawable: CAMetalDrawable, renderPassDescriptor: MTLRenderPassDescriptor)
    func drawableSizeWillChange(_ size: CGSize)
}
