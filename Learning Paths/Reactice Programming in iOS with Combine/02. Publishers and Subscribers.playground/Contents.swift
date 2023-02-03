import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "NotificationCentre") {
  let center = NotificationCenter.default
  let myNotification = Notification.Name("MyNotification")

  let publisher = center
      .publisher(for: myNotification, object: nil)

  let subscription = publisher
    .print()
      .sink { event in
        print(event)
        print("Notification received from a publisher!")
      }

  center.post(name: myNotification, object: nil)
  subscription.cancel()
}

example(of: "Just") {
  let just = Just("Hello World")
  just
    .print()
    .sink(receiveCompletion: { print("Received completion", $0) },
          receiveValue: { print("Received value", $0) })
    .store(in: &subscriptions)
}

example(of: "assign(to:on:)") {
  class SomeObject {
    var value: String = "" {
      didSet {
        print(value)
      }
    }
  }

  let object = SomeObject()

  var array = ["Hello", "World"]
  let publisher = array.publisher
  array.append("I am a new value")

  publisher
    .print()
    .assign(to: \.value, on: object)
    .store(in: &subscriptions)
}

example(of: "Passthrough subject") {
  let subject = PassthroughSubject<String, Never>()

  subject
    .print()
    .sink(receiveCompletion: { print("Received completion", $0) },
          receiveValue: { print("Received value", $0) })
    .store(in: &subscriptions)

  subject.send("Hello world")
  subject.send(completion: .finished)
  subject.send("Hello world 2") // <- This will never be delivered
}

example(of: "CurrentValueSubject") {
  let subject = CurrentValueSubject<String, Never>("Hello world")

  subject
    .print()
    .sink(receiveCompletion: { print("Received completion", $0) },
          receiveValue: { print("Received value", $0) })
    .store(in: &subscriptions)

  subject.value = "Hello world 2" // <- This would also emit an event
  subject.send(completion: .finished)
  subject.send("Hello world 3") // <- This will never be delivered
  var value = subject.value
  print(value) // Prints "Hello world 2"
}

example(of: "Type erasure") {
  let subject = PassthroughSubject<String, Never>()

  subject
    .eraseToAnyPublisher() // <- This is the type erasure
    .print()
    .sink(receiveCompletion: { print("Received completion", $0) },
          receiveValue: { print("Received value", $0) })
    .store(in: &subscriptions)

  subject.send("Hello world")
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
