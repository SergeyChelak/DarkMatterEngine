//
//  RendererSystem.swift
//  DarkMatter
//
//  Created by Sergey on 26.11.2025.
//

import Foundation
import MetalKit

// --- Stub component ---
struct RenderableComponent {
    let meshID: MeshAssetID
    let materialID: MaterialAssetID
}
// --- Stub component ---

final class RendererSystem {
    private let metalContext: MetalContext
    
    private struct RenderData {
        let vertexBuffer: MTLBuffer
        let verticesCount: Int
        let pipelineState: MTLRenderPipelineState
    }
    
    private var data: [RenderData] = []
    
    init(metalContext: MetalContext) {
        self.metalContext = metalContext
    }
    
    var device: MTLDevice {
        metalContext.device
    }
    
    func process(
        /* delta time */
        renderables: [RenderableComponent],
        assetManager: AssetManager
    ) {
        // TODO: this is simplification, synchronization was omitted!!!!!
        self.data = renderables.compactMap { renderable -> RenderData? in
            guard let meshData = assetManager.getMeshData(for: renderable.meshID),
                  let materialId = assetManager.getMaterialData(for: renderable.materialID) else {
                return nil
            }
            return RenderData(
                vertexBuffer: meshData.vertexBuffer,
                verticesCount: meshData.verticesCount,
                pipelineState: materialId.renderPipeline
            )
        }
    }
    
    func render(
        drawable: CAMetalDrawable,
        renderPassDescriptor: MTLRenderPassDescriptor
    ) {
        guard let commandBuffer = metalContext.commandQueue.makeCommandBuffer(),
              let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(
                descriptor: renderPassDescriptor
              ) else {
            return
        }
        
        for elem in data {
            renderCommandEncoder.setRenderPipelineState(elem.pipelineState)
            renderCommandEncoder.setVertexBuffer(elem.vertexBuffer, offset: 0, index: 0)
            renderCommandEncoder.drawPrimitives(
                type: .triangle,
                vertexStart: 0,
                vertexCount: elem.verticesCount
            )
        }
        
        renderCommandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
