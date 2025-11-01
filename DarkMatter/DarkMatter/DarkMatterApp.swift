//
//  DarkMatterApp.swift
//  DarkMatter
//
//  Created by Sergey on 31.10.2025.
//

import SwiftUI
import DarkMatterStorage

@main
struct DarkMatterApp: App {
    private let storage = Storage()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
