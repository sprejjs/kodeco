///// Copyright (c) 2021 Razeware LLC
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

enum FetchError: Error {
  case statusCode(Int)
  case urlResponse
}

struct ContentView: View {

  @State private var songs = [MusicItem]()
  @State private var task: Task<Void, Never>?

  var body: some View {
    VStack {
      Button("Fetch songs") {
        task = Task.init {
          do {
            songs = try await fetchSongs(for: "Marilyn Manson")
          } catch {
            print("Error: \(error)")
            songs = []
          }
        }
      }
      Button("Cancel the task") {
        task?.cancel()
      }
      List(songs) { song in
        Text("\(song.trackName) - \(song.artistName)")
      }
      .task {
        do {
          try await withThrowingTaskGroup(of: [MusicItem].self) { group in
            group.addTask {
              try await fetchSongs(for: "Marilyn Manson")
            }
            group.addTask {
              try await fetchSongs(for: "Eminem")
            }
            songs = try await group.reduce([], +)
          }
        } catch {
          print("Error: \(error)")
          songs = []
        }
      }
    }
  }

  func fetchSongs(for artist: String) async throws -> [MusicItem] {
    print("fetch songs start: \(artist)")
    if #available(iOS 16.0, *) {
      try await Task.sleep(for: .seconds(5))
    } else {
      try await Task.sleep(nanoseconds: 5_000_000_000)
    }
    guard let url = buildItunesUrl(for: artist) else {
      fatalError("Unable to construct a url for \(artist)")
    }

    guard !Task.isCancelled else { // <- Handling cancelation manually
      print("The task was cancelled")
      return []
    }
    try Task.checkCancellation() // <- Letting the framework check for cancelation and throw an error

    let (data, response) = try await URLSession.shared.data(from: url)
    print("received data: \(artist)")
    guard let httpResponse = response as? HTTPURLResponse else {
      throw FetchError.urlResponse
    }
    guard (200..<300).contains(httpResponse.statusCode) else {
      throw FetchError.statusCode(httpResponse.statusCode)
    }

    let decoder = JSONDecoder()
    return try decoder.decode(MediaResponse.self, from: data).results
  }

  func buildItunesUrl(for searchTerm: String) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "itunes.apple.com"
    urlComponents.path = "/search"
    urlComponents.queryItems = [
      URLQueryItem(name: "term", value: searchTerm),
      URLQueryItem(name: "entity", value: "song")
    ]
    return urlComponents.url
  }
}
