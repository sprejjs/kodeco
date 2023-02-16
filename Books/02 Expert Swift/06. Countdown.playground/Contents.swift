/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

struct CountdownIterator: IteratorProtocol {
  var count: Int

  mutating func next() -> Int? {
    guard count >= 0 else {
      return nil
    }

    defer { count -= 1 }
    return count
  }
}

struct Countdown: Sequence {
  var times: Int

  func makeIterator() -> CountdownIterator {
    CountdownIterator(count: times)
  }
}

Countdown(times: 5).forEach {
  print($0)
}

for i in Countdown(times: 5) {
  print(i)
}

print("----")
for value in stride(from: 5, to: 0, by: -1) {
  print(value)
}

print("----")
for value in stride(from: 5, through: 0, by: -1) {
  print(value)
}

print("----")
let sequenceA = sequence(first: 5) { value in
  value > 0 ? value - 1 : nil
}
sequenceA.forEach {
  print($0) // 5, 4, 3, 2, 1, 0
}

print("----")
let sequenceB = sequence(state: 5) { state in
  if state >= 0 {
    defer { state -= 1 }
    return state
  } else {
    return nil
  }
}
sequenceB.forEach {
  print($0) // 5, 4, 3, 2, 1, 0
}

extension Sequence {
  func eraseToAnySequence() -> AnySequence<Element> {
    AnySequence(self)
  }
}

let erased: AnySequence = sequenceB.eraseToAnySequence()

print("----")
let anotherCountdownFrom5 = AnySequence {
  var count = 5

  return AnyIterator<Int> {
    defer { count -= 1}
    return count >= 0 ? count : nil
  }
}
anotherCountdownFrom5.forEach {
  print($0)
}
