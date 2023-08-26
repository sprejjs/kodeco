//
//  ContentView.swift
//  First App
//
//  Created by Allan Spreys on 26/08/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      VStack{
        Text("Hello, world!")
          .fontWeight(.bold)
          .kerning(5.0)
        Image(systemName: "swift")
          .resizable()
          .padding([.leading, .bottom, .trailing])
          .frame(width: 100.0, height: 100.0)
          .background(Color.orange)

      }
      .padding()
    }
}

#Preview {
    ContentView()
}
