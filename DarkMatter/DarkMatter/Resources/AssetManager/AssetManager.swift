//
//  AssetManager.swift
//  DarkMatter
//
//  Created by Sergey on 26.11.2025.
//

import Foundation
import MetalKit

typealias MeshAssetID = String
typealias MaterialAssetID = String

final class AssetManager {
    private let metalContext: MetalContext
    private let pixelFormat: MTLPixelFormat
    
    private var shaderFunctionCache: [String: MTLFunction] = [:]
    private var meshStore: [MeshAssetID: MetalMeshData] = [:]
    private var materialStore: [MaterialAssetID: MetalMaterialData] = [:]
    
    init(
        metalContext: MetalContext,
        pixelFormat: MTLPixelFormat
    ) {
        self.metalContext = metalContext
        self.pixelFormat = pixelFormat
    }
    
    private func shaderFunction(for name: String) -> MTLFunction? {
        if let function = shaderFunctionCache[name] {
            return function
        }
        guard let function = metalContext.library.makeFunction(name: name) else {
            return nil
        }
        shaderFunctionCache[name] = function
        return function
    }
    
    func getMeshData(for id: MeshAssetID) -> MetalMeshData? {
        meshStore[id]
    }
    
    func getMaterialData(for id: MaterialAssetID) -> MetalMaterialData? {
        materialStore[id]
    }
    
    // MARK: --- debug purposes only ---
    func mockLoadMesh() -> MeshAssetID? {
        let vertices: [Vertex] = [
            Vertex(position: Vec3f( 0,  1,  0), color: Vec4f(1,0,0,1)),
            Vertex(position: Vec3f(-1, -1,  0), color: Vec4f(0,1,0,1)),
            Vertex(position: Vec3f( 1, -1,  0), color: Vec4f(0,0,1,1))
        ]
        
        guard let vertexBuffer = metalContext.device.makeBuffer(
            bytes: vertices,
            length: Vertex.stride * vertices.count,
            options: []
        ) else {
            return nil
        }
        
        let id = "msh_1"
        meshStore[id] = MetalMeshData(
            vertexBuffer: vertexBuffer,
            verticesCount: vertices.count
        )
        return id
    }
    
    func mockLoadMaterial(/* here should be material id */) -> MaterialAssetID? {
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        
        let vertexFunction = shaderFunction(for: "basicVertexShader")
        renderPipelineStateDescriptor.vertexFunction = vertexFunction
        
        let fragmentFunction = shaderFunction(for: "basicFragmentShader")
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
        
        renderPipelineStateDescriptor.vertexDescriptor = Vertex.vertexDescriptor
        
        guard let state = try? metalContext.device.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor) else {
            return nil
        }
        let id = "mtrl_1"
        materialStore[id] = MetalMaterialData(renderPipeline: state)
        return id
    }
    // MARK: --- debug purposes only ---
}

// Data Structure for GPU Resources
struct MetalMeshData {
    let vertexBuffer: MTLBuffer
//    let indexBuffer: MTLBuffer
    let verticesCount: Int
//    let indexCount: Int
    // Additional info like bounding box, submeshes, etc.
}

struct MetalMaterialData {
//let baseColorTexture: MTLTexture?
//    let normalTexture: MTLTexture?
    let renderPipeline: MTLRenderPipelineState // The compiled shader
    // Material parameters (shininess, tint color, etc.)
}

/*
struct MetalMeshData {
    let vertexBuffer: MTLBuffer  // Shared by ALL submeshes
    let indexBuffer: MTLBuffer   // Contains ALL indices

    // Array defining the different parts of the model
    let submeshes: [MetalSubmesh]
}

struct MetalSubmesh {
    let indexCount: Int         // How many indices belong to this submesh
    let indexOffset: Int        // Where this submesh starts in the main indexBuffer
    let materialID: MaterialAssetID // The unique material (and thus shader) for this part
}
*/
