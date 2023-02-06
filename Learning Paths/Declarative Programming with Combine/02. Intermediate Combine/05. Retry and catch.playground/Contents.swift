import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var subscriptions = Set<AnyCancellable>()

let photoService = PhotoService()

//example(of: "Retrying") {
//  photoService
//    .fetchPhoto(quality: .high, failingTimes: 2) // <- We are mocking the service
//  // to fail 2 times before turning a successful response
//    .handleEvents(receiveOutput: { // <- This is for debugging purposes only
//      print($0)
//    }, receiveCompletion: {
//      print($0)
//    })
//    .retry(3) // <- We will retry the subscription up to 3 times.
//    .sink(receiveCompletion: {
//      print($0)
//    }, receiveValue: {
//      $0
//      print("Got image: \($0)")
//    })
//    .store(in: &subscriptions)
//}

example(of: "Catch") {
  photoService
    .fetchPhoto(quality: .high) // <- The service is mocked to fail high quality
  // fetch
    .handleEvents(receiveOutput: { // <- This is for debugging purposes only
      print($0)
    }, receiveCompletion: {
      print($0)
    })
    .catch { _ in
      photoService
        .fetchPhoto(quality: .low) // <- When an error occurs we consume it
      // and return a new publisher which will return a lower quality image
    }
    .sink(receiveCompletion: {
      print($0)
    }, receiveValue: {
      $0
      print("Got image: \($0)")
    })
    .store(in: &subscriptions)
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
