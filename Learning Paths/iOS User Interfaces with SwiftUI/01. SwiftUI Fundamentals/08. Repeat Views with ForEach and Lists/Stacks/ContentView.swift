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
  let mix = MeowMix()
  
  var body: some View {
    VStack(spacing: 0.0) {
      MeowMixHeader()
        .padding()
      
      Divider()
        .padding()
      
      // Add a List of tracks
      List(mix.tracks) { track in
        TrackRow(track: track)
      }

      // Add FeaturedCats view
      FeaturedCats(artists: mix.tracks.map(\.artist))
        .padding(.vertical)
        .background(Color.gray.opacity(0.2))
    }
  }
}

struct FeaturedCats: View {
  let artists: [String]
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Featured Cats")
        .font(.title)
        .padding(.leading)
      
      // Add a scrolling horiztonal list of featured artists
      ScrollView(.horizontal) {
        HStack(alignment: .top, spacing: 25) {
          ForEach(artists, id: \.self) { artist in
            FeaturedArtist(artist: artist)
          }
        }
      }
      .padding(.horizontal)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let mix = MeowMix()
    
    ContentView()
    
    FeaturedCats(artists: mix.tracks.map(\.artist))
      .previewLayout(.sizeThatFits)
    
    TrackRow(track: mix.tracks.first!)
      .previewLayout(.sizeThatFits)
    
    FeaturedArtist(artist: "Keyboard Cat")
      .previewLayout(.sizeThatFits)
  }
}

struct TrackRow: View {
  let track: Track
  
  var body: some View {
    HStack {
      track.thumbnail
        .padding()
        .background(track.gradient)
        .cornerRadius(6)
      
      Text(track.title)
      Text(track.artist)
        .foregroundColor(.secondary)
        .lineLimit(1)
        .truncationMode(.tail)
      
      Spacer()
      
      Text("\(track.duration)")
    }
  }
}

struct FeaturedArtist: View {
  let artist: String
  
  var body: some View {
    VStack {
      ZStack {
        Circle()
          .fill([Color.orange, .pink, .purple, .red, .yellow].randomElement()!)
          .scaledToFit()
        
        Image(systemName: "music.mic")
          .resizable()
          .frame(width: 50, height: 50)
          .foregroundColor(.white)
      }
      
      Text(artist)
        .multilineTextAlignment(.center)
        .lineLimit(2)
    }
    .frame(width: 120)
  }
}
