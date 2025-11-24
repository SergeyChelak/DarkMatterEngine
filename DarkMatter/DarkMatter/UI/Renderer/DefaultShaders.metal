//
//  DefaultShaders.metal
//  DarkMatter
//
//  Created by Sergey on 24.11.2025.
//

#include <metal_stdlib>
using namespace metal;


[[vertex]] float4 basicVertexShader(
    constant float3 *vertices [[buffer(0)]],
    uint vertexID [[ vertex_id ]]
) {
    return float4(vertices[vertexID], 1.0);
}

[[fragment]] half4 basicFragmentShader() {
    return half4(1);
}
