//
//  Types.swift
//  DarkMatter
//
//  Created by Sergey on 25.11.2025.
//

import MetalKit

// MARK: - simd
typealias Vec3f = SIMD3<Float>
extension Vec3f: Sizable {}

typealias Vec4f = SIMD4<Float>
extension Vec4f: Sizable {}


// MARK: - sizable
protocol Sizable {
    static var size: Int { get }
    static var stride: Int { get }
}

extension Sizable {
    static var size: Int {
        MemoryLayout<Self>.size
    }
    
    static var stride: Int {
        MemoryLayout<Self>.stride
    }
}

// MARK: -
protocol VertexLayout {
    static var vertexDescriptor: MTLVertexDescriptor { get }
}
