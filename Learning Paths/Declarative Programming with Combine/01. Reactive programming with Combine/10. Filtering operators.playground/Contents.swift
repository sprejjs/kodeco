import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "filter()") {
  (1...10)
    .publisher
    .filter { $0.isMultiple(of: 3) }
    .sink { print($0) } // <- Outputs 3, 6, 9
    .store(in: &subscriptions)
}

example(of: "removeDuplicates()") {
  [
    "a",
    "b",
    "b", // <- This is a duplicate, it won't go through.
    "c",
    "b" // <- We've seen "b" already, however, the last element
    // wasn't "b", so this is not considered to be a duplicate
    // so it will go through.
  ]
    .publisher
    .removeDuplicates()
    .collect()
    .sink { print($0) }
    .store(in: &subscriptions)
}

example(of: "compactMap()") {
  [
    "a", // <- Will skip this value
    "1.24",
    "3",
    "def", // <- Will skip this value
    "45",
    "0.23"
  ]
    .publisher
    .compactMap {
      Float($0)
    }
    .sink {
      print($0)
    }
    .store(in: &subscriptions)
}

example(of: "ignoreOutput()") {
  [1, 2, 3, 4, 5]
    .publisher
    .ignoreOutput()
    .sink(receiveCompletion: { _ in
      print("Received completion event")
    }, receiveValue: {
      print($0) // <- Never called
    })
    .store(in: &subscriptions)
}

example(of: "first()") {
  var subject = PassthroughSubject<Int, Never>()

  subject
    .first { $0.isMultiple(of: 2) }
    .sink(receiveCompletion: { _ in
      print("Received completion event")
    }, receiveValue: {
      print($0) // <- Outputs 2
    })
    .store(in: &subscriptions)

  print("Sending 1")
  subject.send(1)
  print("Sending 2")
  subject.send(2)
  print("Sending 4")
  subject.send(4) // <- The completion event is sent, so the subscription is already
  // cancelled, this value will never be received.
}

example(of: "last()") {
  var subject = PassthroughSubject<Int, Never>()

  subject
    .last { $0.isMultiple(of: 2) }
    .sink(receiveCompletion: { _ in
      print("Received completion event")
    }, receiveValue: {
      print($0) // <- Outputs 4
    })
    .store(in: &subscriptions)

  print("Sending 1")
  subject.send(1)
  print("Sending 2")
  subject.send(2)
  print("Sending 4")
  subject.send(4)
  subject.send(completion: .finished) // <- Doesn't execute anything until the completion event is sent.
}

example(of: "prefix()") {
  var subject = PassthroughSubject<Int, Never>()

  subject
    .prefix(2)
    .sink(receiveCompletion: { _ in
      print("Received completion event")
    }, receiveValue: {
      print($0) // <- Outputs 1, 2
    })
    .store(in: &subscriptions)

  print("Sending 1")
  subject.send(1)
  print("Sending 2")
  subject.send(2)
  print("Sending 3")
  subject.send(3) // <- This value will never be received.
  subject.send(completion: .finished) // <- It's okay to send the completion
  // multiple times
}

example(of: "drop()") {
  var subject = PassthroughSubject<Int, Never>()

  subject
    .dropFirst(2) // <- Drops the first 2 values
    .drop { $0.isMultiple(of: 3) } // <- Drops all values that are multiples of 2
    .sink(receiveCompletion: { _ in
      print("Received completion event")
    }, receiveValue: {
      print("Received value: \($0)") // <- Received value: 4
    })
    .store(in: &subscriptions)

  print("Sending 1")
  subject.send(1) // <- First value is dropped
  print("Sending 2")
  subject.send(2) // <- Second value is dropped
  print("Sending 3")
  subject.send(3) // <- This value doesn't match the second operator,
  // so it is also dropped
  print("Sending 4")
  subject.send(4) // <- This value is received
  print("Sending 5")
  subject.send(5) // <- Drop operators have finished their job, so they forward all
  // events now. This value is received.
  subject.send(completion: .finished)
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
