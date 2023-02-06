import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let rwUrl = URL(string: "https://raywenderlich.com")!

var subscriptions = Set<AnyCancellable>()

// Accept all challenges from Charles or Proxyman for self-signed certificates
class NetworkSSlProxying: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
let delegate = NetworkSSlProxying()
let conf = URLSessionConfiguration.default
let session = URLSession(configuration: conf, delegate: delegate, delegateQueue: nil)

//example(of: "share()") {
//  let subject: Publishers.Share<Publishers.MapKeyPath<URLSession.DataTaskPublisher, Data>> = session
//    .dataTaskPublisher(for: rwUrl)
//    .map(\.data)
//    .share() // <- This will now be passed by reference
//
//  subject
//    .sink(
//      receiveCompletion: {_ in },
//      receiveValue: {
//        print("Received data: \($0)")
//      })
//    .store(in: &subscriptions)
//
//  DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { // <- Race condition
//    subject
//      .sink(
//        receiveCompletion: {_ in },
//        receiveValue: {
//          print("Received data: \($0)") // <- If the first subscription already emitted
//          // the value then this will never be executed.
//        })
//      .store(in: &subscriptions)
//  }
//}

//example(of: "makeConnectable()") {
////  let subject = PassthroughSubject<Data, URLError>()
//  let publisher = session
//    .dataTaskPublisher(for: rwUrl)
//    .map(\.data)
//    .catch() { _ in Just(Data()) } // <- Replaces
//  // errors with a new instance of Data()
//    .makeConnectable()
//
//  publisher
//    .sink(
//      receiveCompletion: {_ in },
//      receiveValue: {
//        print("Received data: \($0)")
//      })
//    .store(in: &subscriptions)
//
//  DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
//    publisher
//      .sink(
//        receiveCompletion: {_ in },
//        receiveValue: {
//          print("Received data: \($0)")
//        })
//      .store(in: &subscriptions)
//
//    publisher
//      .connect()
//      .store(in: &subscriptions)
//  }
//}

example(of: "replaceError") {
  let subject = PassthroughSubject<Data, URLError>()
  let publisher = session
    .dataTaskPublisher(for: rwUrl)
    .map(\.data)
    .replaceError(with: Data()) // <- Replaces errors with a new instance of Data()
    .makeConnectable()

  publisher
    .sink(
      receiveCompletion: {_ in },
      receiveValue: {
        print("Received data: \($0)")
      })
    .store(in: &subscriptions)

  DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
    publisher
      .sink(
        receiveCompletion: {_ in },
        receiveValue: {
          print("Received data: \($0)")
        })
      .store(in: &subscriptions)

    publisher
      .connect()
      .store(in: &subscriptions)
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
