// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

struct FizzBuzz: RandomAccessCollection {
  typealias Index = Int

  var startIndex: Int { 1 }
  var endIndex: Int { 101 }

  subscript(index: Index) -> String {
    precondition(indices.contains(index), "out of range")
    switch (index.isMultiple(of: 3), index.isMultiple(of: 5)) {
    case (false, false):
      return String(describing: index)
    case (false, true):
      return "Buzz"
    case (true, false):
      return "Fizz"
    case (true, true):
      return "FizzBuzz"
    }
  }
}

FizzBuzz().count
