/// Copyright (c) 2023 Kodeco LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView: View {
  var body: some View {
    HStack(alignment: .bottom, spacing: 20) {
      Thumbnail()
      VStack(alignment: .leading) {
        MixDescription()
        Buttons()
      }
    }
    .padding()
    .frame(minHeight: 150, maxHeight: 250)
  }
}

struct Thumbnail: View {
  var body: some View {
    ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .foregroundColor(.orange)
          .aspectRatio(1, contentMode: .fit)
          .shadow(radius: 10)

        Image(systemName: "play.fill")
          .resizable()
          .frame(width: 50, height: 50)
          .foregroundColor(.white)
          .opacity(0.4)
      }
      VStack(alignment: .leading) {
        Text("Meow!")
          .font(.largeTitle)
          .fontWeight(.black)
        Text("Mix")
          .font(.largeTitle)
        Spacer()
      }
      .foregroundColor(.white)
      .padding()
    }
  }
}

struct ButtonLabel: View {

  let title: String
  let systemImage: String

  var body: some View {
    Button(action: { print(title) }, label: {
      HStack {
        Spacer()
        Label(title, systemImage: systemImage)
        Spacer()
      }
      .padding(.vertical)
      .background(Color.gray.opacity(0.15))
      .cornerRadius(12)
    })
  }
}

struct Buttons: View {
  var body: some View {
    HStack(spacing: 12) {
      ButtonLabel(title: "Play", systemImage: "play.fill")
      ButtonLabel(title: "Shuffle", systemImage: "shuffle")
    }
  }
}

struct MixDescription: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 20.0) {
      VStack(alignment: .leading) {
        Text("Meow! Mix")
          .font(.title)
          .fontWeight(.semibold)
        Text("Apple Music for Luna")
          .font(.title)
          .fontWeight(.light)
          .foregroundColor(.accentColor)
        Text("Updated Caturday")
          .font(Font.system(.body).smallCaps())
      }
      Text("Whether you're a kitten or an old-timer, get meowing with this purrsonalized mix of music to meow to!")

    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Image("meowMix")
      .resizable()
      .frame(maxHeight: 250)
      .previewLayout(.sizeThatFits)

    Thumbnail()
      .padding()
      .previewLayout(.fixed(width: 250, height: 250))

    ContentView()
  }
}
