import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "min()") {
  [1, -4, 2]
    .publisher
    .min()
    .sink {
      print($0) // <- -4
    }
    .store(in: &subscriptions)
}

example(of: "max()") {
  [1, -4, 2]
    .publisher
    .max()
    .sink {
      print($0) // <- 2
    }
    .store(in: &subscriptions)
}

example(of: "count()") {
  [1, -4, 2]
    .publisher
    .count()
    .sink {
      print($0) // <- 3
    }
    .store(in: &subscriptions)
}

example(of: "output(in)") {
  (1...5)
    .publisher
    .output(in: 1...3)
    .sink {
      print($0) // <- 2, 3, 4
    }
    .store(in: &subscriptions)
}

example(of: "output(at)") {
  (1...5)
    .publisher
    .output(at: 2)
    .sink {
      print($0) // <- 3
    }
    .store(in: &subscriptions)
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
