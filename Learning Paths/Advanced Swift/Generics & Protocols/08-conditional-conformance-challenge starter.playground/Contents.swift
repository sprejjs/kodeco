// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

struct Pair<Element> {
  var first: Element
  var second: Element
}

extension Pair {
  var flipped: Pair { return Pair(first: second, second: first) }

  func min(by areIncreasingOrder: ((Element, Element)->Bool)) -> Element {
    areIncreasingOrder(first, second) ? first : second
  }

  func max(by areIncreasingOrder: ((Element, Element) -> Bool)) -> Element {
    areIncreasingOrder(first, second) ? second : first
  }

  func sorted(by areIncreasingOrder: (Element, Element) -> Bool) -> Pair<Element> {
    areIncreasingOrder(first, second) ? self : flipped
  }
}

extension Pair: Equatable where Element: Equatable {}

extension Pair: Comparable where Element: Comparable {
  static func < (lhs: Pair<Element>, rhs: Pair<Element>) -> Bool {
    return lhs.first < rhs.second
  }
}

extension Pair: Codable where Element: Codable {}
extension Pair: Hashable where Element: Hashable {}

protocol Orderable {
  associatedtype Element
  func min() -> Element
  func max() -> Element
  func sorted() -> Self
}

extension Pair: Orderable where Element: Comparable {
  func min() -> Element { min(by: <) }
  func max() -> Element { max(by: <) }
  func sorted() -> Pair { sorted(by: <) }
}

let bools = Pair(first: false, second: true)
let ints = Pair(first: 1000, second: 300)

ints.sorted()
ints.max()

let result = bools.sorted { a, b in return !b }
print(result)
