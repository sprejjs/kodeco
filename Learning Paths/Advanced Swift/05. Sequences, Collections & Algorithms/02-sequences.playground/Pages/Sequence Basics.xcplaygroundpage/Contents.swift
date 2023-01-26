// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

////////////////////////////////////////////////////////////////////////////////
// Sequence Basics

struct InfiniteIterator<T>: IteratorProtocol {
  private let constant: T
  typealias Element = T

  mutating func next() -> T? {
    constant
  }

  init(_ constant: T) {
    self.constant = constant
  }
}

struct InfiniteSequence<T>: Sequence {
  private let constant: T
  init(_ constant: T) {
    self.constant = constant
  }

  func makeIterator() -> some IteratorProtocol {
    return InfiniteIterator(constant)
  }
}

var sequence = InfiniteSequence<Int>(42)
