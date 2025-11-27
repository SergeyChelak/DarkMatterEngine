//
//  Simd.swift
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
