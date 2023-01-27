// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

struct FizzBuzz: RandomAccessCollection {
  
  typealias Index = Int
  
  var startIndex: Index {
    return 1
  }
  
  var endIndex: Index {
    return 101
  }
  
  subscript (position: Index) -> String {
    precondition(indices.contains(position), "out of 1-100")
    switch (position.isMultiple(of: 3), position.isMultiple(of: 5)) {
    case (false, false):
      return String(position)
    case (true, false):
      return "Fizz"
    case (false, true):
      return "Buzz"
    case (true, true):
      return "FizzBuzz"
    }
  }
}

var result = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].lazy.filter { $0.isMultiple(of: 3) }.count
print(result)
