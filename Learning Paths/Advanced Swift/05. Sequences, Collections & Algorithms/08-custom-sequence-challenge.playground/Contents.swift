// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

struct Array2D<Element>: BidirectionalCollection, MutableCollection {
  
  let width, height: Int
  private var storage: [Element]
  
  init(width: Int, height: Int, repeating value: Element) {
    self.width = width
    self.height = height
    self.storage = Array(repeating: value, count: width*height)
  }
  
  struct Array2DIndex: Comparable {
    fileprivate(set) var x, y: Int
    static func <(lhs: Index, rhs: Index) -> Bool {
      return lhs.y < rhs.y ||
        (lhs.y == rhs.y && lhs.x < rhs.x)
    }
  }
  
  typealias Index = Array2DIndex
  
  var startIndex: Index {
    return Index(x: 0, y: 0)
  }
  
  var endIndex: Index {
    return Index(x: 0, y: height)
  }
  
  func index(before i: Index) -> Index {
    if i.x > 0 {
      return Index(x: i.x-1, y: i.y)
    }
    precondition(i.y > 0)
    return Index(x: width-1, y: i.y-1)
  }
  
  func index(after i: Index) -> Index {
    if i.x < width-1 {
      return Index(x: i.x+1, y: i.y)
    }
    return Index(x: 0, y: i.y+1)
  }
  
  func inBounds(index: Index) -> Bool {
    return (0..<width).contains(index.x) && (0..<height).contains(index.y)
  }
  
  subscript(index: Index) -> Element {
    get {
      precondition(inBounds(index: index), "out of bounds index \(index)")
      return storage[index.y*width + index.x]
    }
    set {
      precondition(inBounds(index: index), "out of bounds index \(index)")
      storage[index.y*width + index.x] = newValue
    }
  }
  
  subscript(x x: Int, y y: Int) -> Element {
    get {
      return self[Index(x: x, y: y)]
    }
    set {
      self[Index(x: x, y: y)] = newValue
    }
  }
}


// Challenge
// Add custom sequences that run through a particular row or a particular column of
// the array.

extension Array2D {
  func row(_ row: Int) -> AnySequence<Element> {
    var index = Index(x: 0, y:row)
    return AnySequence<Element> {
      AnyIterator<Element> {
        guard index.x < self.width else {
          return nil
        }
        defer { index.x += 1}
        return self[index]
      }
    }
  }

  func column(_ column: Int) -> AnySequence<Element> {
    var index = Index(x: column, y: 0)
    return AnySequence<Element> {
      AnyIterator<Element> {
        guard index.y < height else {
          return nil
        }
        defer { index.y += 1}
        return self[index]
      }
    }
  }
}


var array = Array2D(width: 4, height: 3, repeating: 0)
array[x: 1, y: 2] = 7
array[x: 2, y: 2] = 9
array[x: 3, y: 2] = 12


for items in array.row(2).lazy {
  print(items) // 0,7,9,12
}

print("---")
for items in array.column(1) {
  print(items)  // 0,0,7
}
