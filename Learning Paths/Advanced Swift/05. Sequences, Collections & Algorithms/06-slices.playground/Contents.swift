// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

let array = Array(0...99)

let all = array[...] // This is a slice of an array

let lower = array[..<50] // Also a slice
let upper = array[50...]
let some = array[20...50]
let more = array[10..<11]

var sum = some.reduce(0) { $0 + $1 } // This performs an operation on the slice.
print(sum)

func computeSum1(values: [Int]) -> Int {
  values.reduce(0) { $0 + $1 }
}

//computeSum1(values: upper) // This doesn't compile as the function expect a full array.

func computeSum2<S: Sequence>(values: S) -> S.Element where S.Element: Numeric {
  values.reduce(0) { $0 + $1 }
}

sum = computeSum2(values: upper)
print(sum)

var hello = "Hello, 🌍"
if let range = hello.range(of: "🌍") {
  hello.replaceSubrange(range, with: "🌞!!!")
}
print(hello)

if let index = hello.firstIndex(of: "🌞") {
  let sun: Substring = hello[index...] // This is a slice of a string known as a substring
  print(type(of: sun))
  print(sun)
}
