//
//  DefaultShaders.metal
//  DarkMatter
//
//  Created by Sergey on 24.11.2025.
//

#include <metal_stdlib>
using namespace metal;


[[vertex]] float4 basicVertexShader() {
    return float4(1);
}

[[fragment]] half4 basicFragmentShader() {
    return half4(1);
}
