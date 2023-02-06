import XCTest
import Combine

class CombineOperatorsTests: XCTestCase {
  var subscriptions = [AnyCancellable]()

  override func tearDown() {
    super.tearDown()
    subscriptions = []
  }

  func test_collect() {
    let expectation = XCTestExpectation(description: "collect")

    // GIVEN the publisher emits values 1 through 5
    let publisher = (1...5).publisher

    // WHEN the publisher is collected
    publisher
      .collect()
      .sink { _ in
        expectation.fulfill()
      } receiveValue: { value in
        // THEN the publisher emits a single array of all values
        XCTAssertEqual(value, [1, 2, 3, 4, 5])
      }
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 1)
  }

  func test_flatMap_withMax2Publisher() {
    let expectation = XCTestExpectation(description: "flatMap")
    var subject = PassthroughSubject<AnyPublisher<Any, Never>, Never>()

    // GIVEN three publishers
    var strings = PassthroughSubject<String, Never>()
    var numbers = PassthroughSubject<Int, Never>()
    var doubles = PassthroughSubject<Double, Never>()

    // AND the flatMap has maxPublishers set to 2
    let maxPublishers = 2

    // WHEN the publishers are flatMapped
    subject
      .flatMap(maxPublishers: .max(maxPublishers)) {
        $0
      }
      .collect()
      .sink(receiveCompletion: { _ in
          print("Completed")
      }, receiveValue: { (values: [Any]) in
        let expectedValues: [Any] = ["First", 1, "Second", 2]
        // THEN the publisher emits values from the first two publishers only
        XCTAssertEqual(values.count, expectedValues.count)
        for (value, expectedValue) in zip(values, expectedValues) {
          XCTAssertEqual(value as? AnyHashable, expectedValue as? AnyHashable)
        }

      })
      .store(in: &subscriptions)

    subject.send(strings.map {$0 as Any}.eraseToAnyPublisher())
    subject.send(numbers.map {$0 as Any}.eraseToAnyPublisher())
    subject.send(doubles.map {$0 as Any}.eraseToAnyPublisher())
    strings.send("First")
    numbers.send(1)
    doubles.send(0.6)
    strings.send("Second")
    numbers.send(2)
    subject.send(completion: .finished)
  }
}

CombineOperatorsTests.defaultTestSuite.run()

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
