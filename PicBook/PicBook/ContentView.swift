//
//  ContentView.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            
        }
    }
}

#Preview {
    ContentView()
}
