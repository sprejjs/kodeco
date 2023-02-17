/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

extension Bitmap: RandomAccessCollection, MutableCollection {
  @usableFromInline
  struct Index: Comparable {
    @inlinable static func < (lhs: Index, rhs: Index) -> Bool {
      (lhs.row, lhs.column) < (rhs.row, lhs.column)
    }

    var row, column: Int
  }

  @inlinable var startIndex: Index {
    Index(row: 0, column: 0)
  }

  @inlinable var endIndex: Index {
    Index(row: height, column: 0)
  }

  @inlinable func index(after i: Index) -> Index {
    i.column < width-1 ?
    Index(row: i.row, column: i.column + 1) :
    Index(row: i.row + 1, column: 0)
  }

  @inlinable func index(before i: Index) -> Index {
    i.column > 0 ?
    Index(row: i.row, column: i.column-1) :
    Index(row: i.row-1, column: width-1)
  }

  @inlinable
  func index(_ i: Index, offsetBy distance: Int) -> Index {
    Index(row: i.row + distance / width,
          column: i.column + distance % width)
  }

  @inlinable
  func distance(from start: Index, to end: Index) -> Int {
    (end.row * width + end.column)
       - (start.row * width + start.column)
  }

  @inlinable
  func index(of i: Index, rowOffset: Int, columnOffset: Int) -> Index {
    Index(row: i.row + rowOffset, column: i.column + columnOffset)
  }

  @inlinable func contains(index: Index) -> Bool {
    (0..<width).contains(index.column) &&
     (0..<height).contains(index.row)
  }

  @inlinable subscript(position: Index) -> Pixel {
    get {
      precondition(contains(index: position),
                   "out of bounds index \(position)")
      return pixels[position.row * width + position.column]
    }

    set {
      precondition(contains(index: position),
                   "out of bounds index \(position)")
      pixels[position.row * width + position.column] = newValue
    }
  }

}
