import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "merge") {
  let publisher2 = PassthroughSubject<Int, Never>()
  let publisher1 = PassthroughSubject<Int, Never>()

  publisher1
    .merge(with: publisher2)
    .sink {
      print("Received value: \($0)")
    }
    .store(in: &subscriptions)

  publisher1.send(1)
  publisher1.send(2)

  publisher2.send(3)

  publisher1.send(4)

  publisher2.send(5)
}

example(of: "combineLatest") {
  let publisher2 = PassthroughSubject<String, Never>()
  let publisher1 = PassthroughSubject<Int, Never>()

  publisher1
    .combineLatest(publisher2)
    .sink {
      print("Received value: \($0)")
    }
    .store(in: &subscriptions)

  publisher1.send(1) // <- Does not emit because publisher2 has not published
  publisher1.send(2) // <- Does not emit because publisher2 has not published

  publisher2.send("a") // <- Emits 2a
  publisher2.send("b") // <- Emits 2b

  publisher1.send(3) // <- Emits 3b

  publisher2.send("c") // <- Emits 3c
}

example(of: "zip") {
  let publisher2 = PassthroughSubject<String, Never>()
  let publisher1 = PassthroughSubject<Int, Never>()

  publisher1
    .zip(publisher2)
    .sink {
      print("Received value: \($0)")
    }
    .store(in: &subscriptions)

  publisher1.send(1) // <- Does not emit because publisher2 has not published
  publisher1.send(2) // <- Does not emit because publisher2 has not published

  publisher2.send("a") // <- Emits 1a
  publisher2.send("b") // <- Emits 2b

  publisher1.send(3) // <- Does not emit because publisher2 has not published

  publisher2.send("c") // <- Emits 3c
}

example(of: "switchToLatest") {
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<Int, Never>()
  let publisher3 = PassthroughSubject<Int, Never>()

  let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()

  publishers
    .switchToLatest()
    .sink {
      print("Received value: \($0)")
    }
    .store(in: &subscriptions)

  publishers.send(publisher1)
  publisher1.send(1)
  publisher1.send(2)

  publishers.send(publisher2)
  publisher1.send(3) // <- Does not emit because publisher2 is the latest
  publisher2.send(4)
  publisher2.send(5)

  publishers.send(publisher3)
  publisher2.send(6) // <- Does not emit because publisher3 is the latest
  publisher3.send(7)
  publisher3.send(8)

  publishers.send(publisher2)
  publisher3.send(9) // <- Does not emit because publisher2 is the latest
  publisher2.send(10)
  publisher2.send(11)
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
