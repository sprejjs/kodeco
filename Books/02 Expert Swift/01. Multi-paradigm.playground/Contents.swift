/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

let numbers = [1, 2, 4, 10, -1, 2, -10]

example("Working with memory directly") {
  let pointer = malloc(100) // <- Allocate memory of size of 100 bytes
  // and store the pointer

  defer { // <- execute before the scope returns
    free(pointer) // <- Release the memory
  }
}

example("imperative") {
  var total = 0
  for value in numbers {
    total += value
  }
  print("Total: \(total)")
}

example("functional") {
  let total = numbers.reduce(0, +)

  print("Total: \(total)")
}

example("Exit on negative, imperative approach") {
  var total = 0
  var numberOfElementsEvaluated: Int = 0
  for value in numbers {
    numberOfElementsEvaluated += 1
    guard value >= 0 else {
      break
    }
    total += value
  }
  print("Total: \(total)")
  print("Number of elements evaluated: \(numberOfElementsEvaluated)") // <- 5
}

example("Exit on negative, functional approach") {
  var numberOfElementsEvaluated: Int = 0
  let total = numbers
    .reduce((accumulating: true, total: 0)) { (state, value) in
      numberOfElementsEvaluated += 1
      if state.accumulating && value >= 0 {
        return (accumulating: true, total: state.total + value)
      } else {
        return (accumulating: false, total: state.total)
      }

    }
    .total

  print("Total: \(total)")
  print("Number of elements evaluated: \(numberOfElementsEvaluated)") // <- 7
}

example("Exit on negative, imperative with just-in-time mutability") {
  let total = {
    var total: Int = 0
    for value in numbers {
      guard value >= 0 else {
        break
      }
      total += value
    }
    return total
  }()

  print("Total: \(total)")
}

example("Overflow detection") {
//  let value: Int8 = 115 + 100
}

example("Definitive initialisation") {
  struct Hello {
    let name: String
  }

  let test: Hello // <- defined but not initialised

  if Bool.random() {
    test = .init(name: "😊")
  } else {
    test = .init(name: "☹️")
  }

  print(test.name) // Safe to use as all of the logic paths lead
  // to initialisation.
}



example("Adding a language feature") {

  func expensiveValue1() -> Int {
    print("side effect 1")
    return 2
  }

  func expensiveValue2() -> Int {
    print("side effect 2")
    return 1265
  }

  let value = ifelse(.random(), expensiveValue1(), expensiveValue2())
}
