// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

let elements = ["A", "B", "C", "D"]

print("All Unique Pairs of Elements")

elements.pairs().forEach { print($0) }

public extension Collection {
  func pairs() -> AnySequence<(Element, Element)> {
    guard
      var index1 = index(startIndex, offsetBy: 0, limitedBy: endIndex),
      var index2 = index(index1, offsetBy: 1, limitedBy: endIndex)
    else {
      return AnySequence { EmptyCollection.Iterator() }
    }

    return AnySequence {
      AnyIterator {
        if index1 >= self.endIndex || index2 >= self.endIndex {
          return nil
        }
        defer {
          index2 = self.index(after: index2)
          if index2 >= self.endIndex {
            index1 = self.index(after: index1)
            index2 = self.index(after: index1)
          }
        }
        return (self[index1], self[index2])
      }
    }
  }
}
