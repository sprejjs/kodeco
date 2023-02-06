import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var subscriptions = Set<AnyCancellable>()

example(of: "Dynamically adjusted demand") {
  final class IntSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never

    func receive(subscription: Subscription) {
      subscription.request(.max(2)) // <-- Initials subscription allows
      // up to 2 elements
    }

    func receive(_ input: Int) -> Subscribers.Demand {
      print("Received value: \(input)")
      switch input {
      case 1:
        return .max(1) // <- if the received value is "1", the
        // subscription is increased by 1 element, now we are allowing up to
        // 3 values
      case 2:
        return .max(2) // <- if the received value is "2", the
        // subscription is increased by 2 elements, now we are allowing up to
        // 5 values.
      default:
        return .none
      }
    }

    func receive(completion: Subscribers.Completion<Never>) {
      print("Received completion: \(completion)")
    }
  }

  let subscriber = IntSubscriber()

  let subject = PassthroughSubject<Int, Never>()
  subject
    .subscribe(subscriber)

  (1...10).forEach {
    subject.send($0) // <- Prints values 1-5
  }
}

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
