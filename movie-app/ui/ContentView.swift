//
//  ContentView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 22..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(Fonts.title)
            Text("teszt")
                .font(Fonts.subheading)

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
