/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

struct StructPoint {
  var x, y: Double
}

extension StructPoint {
  init(x: Double) { // <- The initialiser is defined in an extension
    self.x = x
    self.y = x+1
  }
}

let myPoint = StructPoint(x: 1, y: 2) // <- This is fine

class ClassPoint {
  var x, y: Double

  init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
}

// Value semantics vs reference semantics
let myStructA = StructPoint(x: 1, y: 2)
var myStructB = myStructA
myStructB.x = 3
print(myStructA.x) // <- The value hasn't changed, it's 1

let myClassA = ClassPoint(x: 1, y: 2)
var myClassB = myClassA
myClassB.x = 3
print(myClassA.x) // <- The value has changed, it's 3

let myPointA = StructPoint(x: 0, y: 2)
//myPointA.y += 1 // <- ❎ Left side of mutating operator isn't mutable: 'myPointA'
// is a 'let' constant

let myPointB = ClassPoint(x: 0, y: 2)
myPointB.y += 1 // <- ✅ This is fine

class SubclassPoint: ClassPoint {} // ✅ This is fine
// struct SubstructPoint: StructPoint {} // ❎ Inheritance from non-protocol type 'StructPoint'

struct Point: Equatable {
  var x, y: Double
}

struct Size: Equatable {
  var width, height: Double
}

struct Rectangle: Equatable {
  var origin: Point
  var size: Size
}

extension Point {
  func flipped() -> Self {
    Point(x: y, y: x)
  }

  mutating func flip() {
    self = flipped()
  }
}

extension StructPoint {
  mutating func printDebugDescription() {
    print("x: `\(self.x)`; y: `\(self.y)`")

    self.x = 6 // <- ✅
  }
}

func incrementPoint(point: inout StructPoint) {
  point.x += 1
  point.y += 1
}

func incrementPoint(point: inout ClassPoint) {
  point.x += 1
  point.y += 1
}

var point = StructPoint(x: 0, y: 1)
incrementPoint(point: &point)
print(point) // <- Point(x: 1.0, y: 2.0)

var point2 = ClassPoint(x: 0, y: 1)
incrementPoint(point: &point2)
print(point2.x, point2.y)

let a = Measurement(value: .pi/2,
                    unit: UnitAngle.radians)

let b = Measurement(value: 90,
                    unit: UnitAngle.degrees)

print(a + b)  // 180 degrees

struct Email: RawRepresentable {
  var rawValue: String // <- rawValue is required by the protocol

  init?(rawValue: String) { // <- This initialisation is a
   // convention, is it not required by the protocol.
    guard rawValue.contains("@") else {
      return nil
    }
    self.rawValue = rawValue
  }
}

func send(message: String, to recipient: Email) throws {
  // some implementation
}

enum Direction: Int {
  case up, down, left, right
}

print(Direction.up.rawValue) // ✅ <- `rawValue` is available because
// direction conforms to RawValueRepresentable.
