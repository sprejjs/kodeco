// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

struct Pair<T> {
  let a, b: T

  init(_ a: T, _ b: T) {
    self.a = a
    self.b = b
  }
}

extension Pair {
  var flipped: Pair {
    Pair(b, a)
  }
}

let a = Pair(2, 3)
let b = Pair(3, 2)

// By default the below code won't compile with the following error:
// Binary operator '==' cannot be applied to two 'Pair<Int>' operands
// This can be resolved by adding conditional conformance to the Type.
print(a == b)

extension Pair: Equatable where T: Equatable {}

extension Pair: Comparable where T: Comparable {
  static func < (lhs: Pair<T>, rhs: Pair<T>) -> Bool {
    lhs.a < rhs.b
  }
}

protocol Orderable {
  associatedtype Element

  func min() -> Element
  func max() -> Element
  func sorted() -> Self
}

extension Pair: Orderable where T: Comparable {
  typealias Element = T

  func min() -> T {
    Swift.min(a, b)
  }

  func max() -> T {
    Swift.max(a, b)
  }

  func sorted() -> Pair {
    Pair(self.min(), self.max())
  }
}

let pair = Pair(2, 6)
print(pair.flipped)
print(pair.min())
print(pair.max())

let bools = Pair(true, false)
// bools.sorted() won't compile because bools are not Comparable
