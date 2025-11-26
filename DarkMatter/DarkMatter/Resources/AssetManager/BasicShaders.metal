//
//  BasicShaders.metal
//  DarkMatter
//
//  Created by Sergey on 24.11.2025.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct RasterizedData {
    float4 position [[ position ]];
    float4 color;
};


[[vertex]] RasterizedData basicVertexShader(
    const Vertex v [[ stage_in ]]
) {
    return RasterizedData {
        float4(v.position, 1.0),
        v.color,
    };
}

[[fragment]] half4 basicFragmentShader(
    const RasterizedData rd [[ stage_in ]]
) {
    auto color = rd.color;
    return half4(color.r, color.g, color.b, color.a);
}
