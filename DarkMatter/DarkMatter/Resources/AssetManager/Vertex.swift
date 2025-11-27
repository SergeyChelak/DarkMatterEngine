//
//  Vertex.swift
//  DarkMatter
//
//  Created by Sergey on 25.11.2025.
//

import MetalKit

struct Vertex: Sizable {
    let position: Vec3f
    let color: Vec4f
}

extension Vertex {
    // Warn: must me aligned with shader
    static let vertexDescriptor: MTLVertexDescriptor = {
        let vertexDescriptor = MTLVertexDescriptor()
        // position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        // color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = Vec3f.stride
        
        vertexDescriptor.layouts[0].stride = Vertex.size
        return vertexDescriptor
    }()
}
