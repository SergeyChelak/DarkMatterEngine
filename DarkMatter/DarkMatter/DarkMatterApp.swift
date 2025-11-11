//
//  DarkMatterApp.swift
//  DarkMatter
//
//  Created by Sergey on 31.10.2025.
//

import SwiftUI

@main
struct DarkMatterApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    NSApplication.shared.windows.forEach {
                        $0.hideAllElements()
                    }
                }
                .onDisappear {
                    Darwin.exit(0)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .commandsRemoved()
    }
}
