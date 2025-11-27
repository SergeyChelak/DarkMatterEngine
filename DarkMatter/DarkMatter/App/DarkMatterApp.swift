//
//  DarkMatterApp.swift
//  DarkMatter
//
//  Created by Sergey on 31.10.2025.
//

import SwiftUI

@main
struct DarkMatterApp: App {
    private let engine = makeEngine()
        
    var body: some Scene {
        WindowGroup {
            engine.view
                .viewRepresentable()
                .onAppear {
                    engine.run()
                }
                .onDisappear {
                    Darwin.exit(0)
                }
        }
        .commandsRemoved()
    }
}
