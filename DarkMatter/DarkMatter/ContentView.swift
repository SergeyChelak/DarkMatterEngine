//
//  ContentView.swift
//  DarkMatter
//
//  Created by Sergey on 31.10.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Dark Matter Game Engine")
            Button("Terminate") {
                Darwin.exit(0)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
