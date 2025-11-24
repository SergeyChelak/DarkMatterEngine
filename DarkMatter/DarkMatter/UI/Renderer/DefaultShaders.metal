//
//  DefaultShaders.metal
//  DarkMatter
//
//  Created by Sergey on 24.11.2025.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float3 position;
    float4 color;
};

struct RasterizedData {
    float4 position [[ position ]];
    float4 color;
};


[[vertex]] RasterizedData basicVertexShader(
    constant Vertex *vertices [[buffer(0)]],
    uint index [[ vertex_id ]]
) {
    return RasterizedData {
        float4(vertices[index].position, 1.0),
        vertices[index].color,
    };
}

[[fragment]] half4 basicFragmentShader(
    const RasterizedData rd [[ stage_in ]]
) {
    auto color = rd.color;
    return half4(color.r, color.g, color.b, color.a);
}
