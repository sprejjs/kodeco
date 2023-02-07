/// Copyright (c) 2021 Razeware LLC
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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import ChuckNorrisJokesModel

struct SavedJokesView: View {
  var body: some View {
    VStack {
      NavigationView {
        List {
          ForEach(jokes, id: \.self) { (joke: JokeManagedObject) in
            Text((showTranslation ? joke.translatedValue : joke.value) ?? "N/A")
              .lineLimit(nil)
          }
          .onDelete { indices in
            jokes.delete(at: indices, inViewContext: viewContext)
          }
        }
        .navigationBarTitle("Saved Jokes")
        .navigationBarItems(trailing:
          Button(action: {
            self.showTranslation.toggle()
          }) {
            Text("Toggle Language")
          }
        )
      }
      
      Button(action: {
        let url = URL(string: "http://translate.yandex.com")!
        UIApplication.shared.open(url)
      }) {
        Text("Translations Powered by Yandex.Translate")
          .font(.caption)
      }
      .opacity(showTranslation ? 1 : 0)
      .animation(.easeInOut)
    }
  }
  
  @State private var showTranslation = false
  @Environment(\.managedObjectContext) var viewContext

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \JokeManagedObject.value, ascending: true)],
    animation: .default
  )
  private var jokes: FetchedResults<JokeManagedObject>
}

struct SavedJokesView_Previews: PreviewProvider {
  static var previews: some View {
    SavedJokesView()
  }
}
