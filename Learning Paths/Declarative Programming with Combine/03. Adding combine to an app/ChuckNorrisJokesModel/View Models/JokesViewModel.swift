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

import UIKit
import Combine
import SwiftUI

public final class JokesViewModel: ObservableObject {
  public enum DecisionState {
    case disliked, undecided, liked
  }
  
  private static let decoder = JSONDecoder()

  @Published public var fetching: Bool = false
  @Published public var joke: Joke = Joke.starter
  @Published public var backgroundColor = Color("Gray")
  @Published public var decisionState: DecisionState = .undecided
  @Published public var showTranslation = false

  private let jokesService: JokeServiceDataPublisher
  private let translationService: TranslationServiceDataPublisher

  private var subscriptions = Set<AnyCancellable>()
  private var jokeSubscriptions = Set<AnyCancellable>()

  public init(jokesService: JokeServiceDataPublisher = JokesService(),
              translationService: TranslationServiceDataPublisher = TranslationService()) {
    self.jokesService = jokesService
    self.translationService = translationService

    $joke // <- Accessing the publisher of the "joke" property
      .map { _ in false } // <- Whenever it publishes any value we produce "false"
      .assign(to: \.fetching, on: self) // <- And assign it to the "fetching" property.
      .store(in: &subscriptions)
  }
  
  public func fetchJoke() {
    fetching = true // <- Updating the "fetching" property to "true" to indicate the network request

    jokeSubscriptions = [] // <- Clearing old subscriptions if any

    jokesService
      .publisher()
      .retry(1)
      .decode(type: Joke.self, decoder: Self.decoder)
      .replaceError(with: Joke.error)
      .receive(on: DispatchQueue.main)
      .handleEvents (receiveOutput: { [unowned self] output in
        self.joke = output
      })
      .filter { $0 != Joke.error }
      .flatMap { [unowned self] in
        self.fetchTranslation(for: $0, to: "es")
      }
      .receive(on: DispatchQueue.main)
      .assign(to: \.joke, on: self)
      .store(in: &jokeSubscriptions)
  }
  
  func fetchTranslation(for joke: Joke, to languageCode: String)
    -> AnyPublisher<Joke, Never> {
      guard joke.languageCode != languageCode else {
        return Just(joke)
          .eraseToAnyPublisher()
      }

      return self.translationService
        .publisher(for: joke, to: languageCode)
        .retry(1)
        .decode(type: TranslationResponse.self, decoder: Self.decoder)
        .compactMap { $0.translations.first }
        .map {
          Joke(
            id: joke.id,
            value: joke.value,
            categories: joke.categories,
            languageCode: languageCode,
            translatedValue: $0)
        }
        .replaceError(with: Joke.error)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
  }
  
  public func updateBackgroundColorForTranslation(_ translation: Double) {
    switch translation {
    case ...(-0.5):
      backgroundColor = Color("Red")
    case 0.5...:
      backgroundColor = Color("Green")
    default:
      backgroundColor = Color("Gray")
    }
  }

  public func updateDecisionStateForTranslation(
    _ translation: Double,
    andPredictedEndLocationX x: CGFloat,
    inBounds bounds: CGRect) {
    switch (translation, x) {
    case (...(-0.6), ..<0):
      decisionState = .disliked
    case (0.6..., bounds.width...):
      decisionState = .liked
    default:
      decisionState = .undecided
    }
  }
  
  public func reset() {
    backgroundColor = Color("Gray")
  }
}
