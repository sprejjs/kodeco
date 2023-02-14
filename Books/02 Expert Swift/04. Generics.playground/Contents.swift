import UIKit

var greeting = "Hello, playground"

func replaceNilValues<T>(from array: [T?], with element: T) -> [T] {
  array.compactMap {
    $0 == nil ? element : $0
  }
}

let numbers: [Int?] = [32, 3, 24, nil, 4]

let filledNumbers = replaceNilValues(from: numbers, with: 42)
print(filledNumbers)

func combineToTuple<t, U>(a: t, b: U) -> (t, U) {
  return (a, b)
}

func max<T: Comparable>(lhs: T, rhs: T) -> T {
  lhs > rhs ? lhs : rhs
}

protocol Example {
  associatedtype Test
}

struct ExampleStruct: Example {
  typealias Test = String
}

//struct Miles: UnitOfMeasurement {
//  func maxSpeed() -> Int { // <- The method returns an `Int` which is enough for
//    // the Swift compiler to infer the associated type
//    return 12
//  }
//}



//func fetch(_ unit: UnitOfMeasurement) { // ❎ Unable to use PAT as a type
//}


//func fetch<P: UnitOfMeasurement>(_ unit: P) { // ✅ This is fine in older versions of Swift
//}

protocol UnitOfMeasurement {
  associatedtype Unit
}
func fetch(_ unit: any UnitOfMeasurement) { // ✅ This is fine as of Swift 5.6
}
