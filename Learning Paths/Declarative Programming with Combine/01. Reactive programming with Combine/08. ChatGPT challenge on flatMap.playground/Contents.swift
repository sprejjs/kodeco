import UIKit
import Combine

// Create a publisher that:
// 1. Emits a string "First" after 0.5 seconds
// 2. Emits an integer 1 after 1 second
// 3. Emits a string "Second" after 1.5 seconds
// 4. Emits an integer 2 after 2 seconds
// 5. Completes after 2.5 seconds
//
// Then, create a subscriber that:
// 1. Prints each received value
// 2. Marks the completion of the subscription when the publisher completes
import PlaygroundSupport
import Combine

PlaygroundPage.current.needsIndefiniteExecution = true

var strings = PassthroughSubject<String, Never>()
var numbers = PassthroughSubject<Int, Never>()
var doubles = PassthroughSubject<Double, Never>()

var subject = PassthroughSubject<AnyPublisher<Any, Never>, Never>()
var subscriptions = Set<AnyCancellable>()

subject
  .flatMap(maxPublishers: .max(2)) { $0 }
  .print()
  .sink(receiveCompletion: { _ in
    print("Completed")
  }, receiveValue: { value in
    print(value)
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

