import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "prepend variadic values") {
  (1...2)
    .publisher
    .prepend(-2, -1, 0)
    .sink {
      print("Received value: \($0)")
    }
    .store(in: &subscriptions)
}

example(of: "prepend sequence") {
  (1...2)
    .publisher
    .prepend([-2, -1, 0])
    .sink {
      print("Received value: \($0)")
    }
    .store(in: &subscriptions)
}

example(of: "prepend publisher") {
  let publisher = PassthroughSubject<Int, Never>()
  (1...2)
    .publisher
    .prepend(publisher)
    .sink {
      print("Received value: \($0)")
    }
    .store(in: &subscriptions)
  publisher.send(-2)
  publisher.send(-1)
  publisher.send(0)
  publisher.send(completion: .finished) // <- The upstream will
  // not emit until the publisher is completed.
}

example(of: "append variadic values") {
  (0...1)
    .publisher
    .append(2, 3)
    .sink {
      print("Received value: \($0)")
    }
    .store(in: &subscriptions)
}

example(of: "append sequence") {
  (0...1)
    .publisher
    .append([2, 3])
    .sink {
      print("Received value: \($0)")
    }
    .store(in: &subscriptions)
}

example(of: "append publisher") {
  let publisher = PassthroughSubject<Int, Never>()
  (0...1)
    .publisher
    .append(publisher)
    .sink {
      print("Received value: \($0)")
    }
    .store(in: &subscriptions)
  publisher.send(2)
  publisher.send(3)
  publisher.send(completion: .finished)
}

/*
 Copyright (c) 2019 Razeware LLC

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 distribute, sublicense, create a derivative work, and/or sell copies of the
 Software in any work that is designed, intended, or marketed for pedagogical or
 instructional purposes related to programming, coding, application development,
 or information technology.  Permission for such use, copying, modification,
 merger, publication, distribution, sublicensing, creation of derivative works,
 or sale is expressly withheld.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
