//
//  RendererEnvironment.swift
//  DarkMatter
//
//  Created by Sergey on 25.11.2025.
//

import Foundation

final class RendererEnvironment {
    let metalContext: MetalContext
    let config: RendererConfiguration
    
    init(
        metalContext: MetalContext,
        config: RendererConfiguration
    ) {
        self.metalContext = metalContext
        self.config = config
    }
}

func makeStandardRenderEnvironment() throws -> RendererEnvironment {
    RendererEnvironment(
        metalContext: try makeMetalContext(),
        config: .standard
    )
}

// TODO: looks like a temporary one
protocol RendererEnvironmentAccessors {
    var environment: RendererEnvironment { get }
    var metal: MetalContext { get }
    var config: RendererConfiguration { get }
}

extension RendererEnvironmentAccessors {
    var metal: MetalContext { environment.metalContext }
    var config: RendererConfiguration { environment.config }
}
