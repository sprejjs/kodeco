/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

// Turn the array into a type-erased sequence
let result: AnySequence<String> = AnySequence(["a", "tale", "of", "two", "cities"])

// Write an extension on Sequence called countingDown() that returns an array of tuples of remaining count and elements.
// For example, the array from question one returns: [(4, "cities"), (3, "two"), (2, "of"), (1, "tale"), (0, "a")].
// Hint: Existing sequence algorithms enumerated() and reversed() might help you do the job with minimal code.

extension Sequence {
  func countingDown() -> [(Int, Element)] {
    self
      .enumerated()
      .reversed()
      .map {
        return ($0.offset, $0.element)
      }
  }
}
print(result.countingDown())

// Create a function primes(to value: Int) -> AnySequence<Int>
// that creates a sequence of the prime numbers up to and possibly including value.
// Brute force prime finding is fine. For example, primes(through: 32) will return
// [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31].

func primes(through value: Int) -> AnySequence<Int> {
  return AnySequence {
    var currentValue = 2
    let maxValue: Int = value

    return AnyIterator<Int> {
      var isPrime = true
      repeat {
        isPrime = true
        for i in 2..<currentValue {
          if (currentValue.isMultiple(of: i)) {
            isPrime = false
            break
          }
        }
        currentValue += 1
      } while (!isPrime && currentValue <= maxValue)

      guard currentValue < maxValue else {
        return isPrime ? currentValue - 1 : nil
      }
      return currentValue - 1
    }
  }
}
print(Array(primes(through: 31)))
