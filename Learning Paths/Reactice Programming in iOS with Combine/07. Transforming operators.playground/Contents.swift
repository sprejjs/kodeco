import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "collect()") {
  var subject = PassthroughSubject<Int, Never>()

  subject
    .collect()
    .print()
    .sink { _ in

    }
    .store(in: &subscriptions)
  subject.send(1)
  subject.send(2)
  subject.send(3)
  subject.send(completion: .finished)
}

example(of: "collect(2)") {
  var subject = PassthroughSubject<Int, Never>()

  subject
    .collect(2)
    .print()
    .sink { _ in

    }
    .store(in: &subscriptions)
  subject.send(1)
  subject.send(2) // <- 2nd element is collected, so the operator will
  // activate.
  subject.send(3) // <- 3rd element is collected into the next batch
  // of events.
  subject.send(completion: .finished)
}

example(of: "map") {
  [1, 2, 3]
    .publisher
    .map {
      $0 * 2
    }
    .print()
    .sink { _ in }
    .store(in: &subscriptions)
}

example(of: "replaceNil") {
  [1, nil, 3]
    .publisher
    .replaceNil(with: 2)
    .print()
    .sink { _ in }
    .store(in: &subscriptions)
}

example(of: "replaceEmpty") {
  var subject = PassthroughSubject<Int, Never>()
  subject
    .replaceEmpty(with: 42)
    .print()
    .sink { _ in } // <- Receives 42.
    .store(in: &subscriptions)

  subject.send(completion: .finished) // <- Subject doesn't send any values prior to completion
}

example(of: "Empty") {
  var subject = Empty<Int, Never>()

  subject
    .print()
    .sink { _ in } // <- Only sends completion.
    .store(in: &subscriptions)
}

example(of: "scan") {
  [1, 2, 3]
    .publisher
    .scan(0) { $0 + $1 }
    .print()
    .sink { _ in } // <- Emits 1, 3, 6
    .store(in: &subscriptions)
}

example(of: "reduce") {
  [1, 2, 3]
    .publisher
    .reduce(0) { $0 + $1 }
    .print()
    .sink { _ in } // <- Emits 6
    .store(in: &subscriptions)
}

example(of: "flatMap") {
  let numbers = PassthroughSubject<Int, Never>()
  let strings = PassthroughSubject<String, Never>()

  let subject = PassthroughSubject<AnyPublisher<Any, Never>, Never>()

  subject
    .flatMap { $0 }
    .sink(receiveValue: { value in
      switch value {
        case let number as Int:
          print("Received integer value: \(number)")
        case let string as String:
          print("Received string value: \(string)")
        default:
          print("Received unknown value")
      }
    })
    .store(in: &subscriptions)

  subject.send(numbers.map { $0 as Any}.eraseToAnyPublisher())
  numbers.send(1)
  strings.send("hello")
  numbers.send(2)
  subject.send(strings.map { $0 as Any}.eraseToAnyPublisher())
  strings.send("world")
}

/// Copyright (c) 2020 Razeware LLC
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
