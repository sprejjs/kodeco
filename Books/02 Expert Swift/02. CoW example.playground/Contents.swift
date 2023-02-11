/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

struct IntStruct {
  var storage: IntWrapper

  var value: Int {
    get {
      return storage.value
    }
    set {
      if !isKnownUniquelyReferenced(&storage) {
        storage = IntWrapper(newValue)
      } else {
        storage.value = newValue
      }
    }
  }

  init(_ value: Int) {
    self.storage = IntWrapper(value)
  }

  final class IntWrapper {
    var value: Int
    init(_ value: Int) {
      self.value = value
    }
  }
}

var valueA = IntStruct(2)
var valueB = valueA
print(valueA.storage === valueB.storage) // true

valueB.value = 3
print(valueA.value) // 2
print(valueB.value) // 3

print(valueA.storage === valueB.storage) // true
