// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

// A two dimensional array with non-integer indices.

struct Array2D<Element> {

  let width, height: Int
  private var storage: [Element]

  init(width: Int, height: Int, repeating value: Element) {
    self.width = width
    self.height = height
    self.storage = Array(repeating: value, count: width*height)
  }
}

extension Array2D {
  subscript(x x: Int, y y: Int) -> Element {
    get { storage[width*y + x] }
    set { storage[width*y+x] = newValue }
  }
}

extension Array2D: CustomDebugStringConvertible {
  var debugDescription: String {
    var result: String = ""
    for i in 0..<height {
      for j in 0..<width {
        result += String(describing:self[x: j, y:i])
      }
      result += "\n"
    }
    return result
  }
}

extension Array2D: BidirectionalCollection, MutableCollection {
  subscript(position: Index) -> Element {
    get {
      self[x: position.x, y: position.y]
    }
    set(newValue) {
      self[x: position.x, y: position.y] = newValue
    }
  }

  func index(before i: Index) -> Index {
    if i.x > 0 {
      return Index(x: i.x - 1, y: i.y)
    }

    precondition(i.y > 0)
    return Index(x: width-1, y: i.y - 1)
  }

  func index(after i: Index) -> Index {
    if i.x < width - 1 {
      return Index(x: i.x+1, y: i.y)
    }

    return Index(x: 0, y: i.y + 1)
  }

  var startIndex: Index {
    Index(x: 0, y: 0)
  }

  var endIndex: Index {
    Index(x: 0, y: height)
  }

  struct Index: Comparable {
    private(set) var x, y: Int
    static func < (lhs: Index, rhs: Index) -> Bool {
      return lhs.y < rhs.y || (lhs.y == rhs.y && lhs.x < rhs.x)
    }
  }
}

var array = Array2D(width: 5, height: 3, repeating: "X")

array[Array2D.Index(x: 0, y: 1)] = "Y"
print(array)
