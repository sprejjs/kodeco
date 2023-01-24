// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import CoreGraphics

struct Circle {
  var origin: CGPoint
  var radius: CGFloat
}

let circle = Circle(origin: .zero, radius: 10)
let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))

protocol Geometry {
  var origin: CGPoint { get set }
  func area() -> CGFloat
}

// Example of retroactive modelling.
// here we add "Geometry" conformance to the `CGRect` model even though we don't have the source code for CGRect.
extension CGRect: Geometry {
  func area() -> CGFloat {
    size.width * size.height
  }
}

// And we can add conformance to our own types
extension Circle: Geometry {
  func area() -> CGFloat {
    .pi * radius * radius
  }
}

// Here we can keep both Circle model and CGRect models in the same array thanks to the conformance to `Geometry` protocol
let shapes: [Geometry] = [circle, rect]
let area = shapes.reduce(0) { $0 + $1.area() }

print(area)
