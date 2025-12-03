//
//  Video.swift
//  DarkMatterWorld
//
//  Created by Sergey on 03.12.2025.
//

import MetalKit

public protocol Video {
    @MainActor var view: MTKView { get }
    func attach(renderer: RenderableSystem)
}
