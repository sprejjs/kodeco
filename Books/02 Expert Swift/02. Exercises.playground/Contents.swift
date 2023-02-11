/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

// 1. Generate 100 random points in the unit circle.
// How many are found in the second quadrant?
// Demonstrate the solution with code.
// Use `PermutedCongruential` with the seed 4321
// to make your answer repeatable.

var pcg = PermutedCongruential(seed: 4321)

let numberOfPointsInSecondQuadrant = (0...99)
  .map { _ in Point.random(inRadius: 1, using: &pcg) }
  .map (Quadrant.init)
  .reduce(0) { (cumulative, value) -> Int in
    if case .ii = value {
      return cumulative + 1
    }

    return cumulative
  }

print("There are \(numberOfPointsInSecondQuadrant) in the second quadrant")

// 2. How many cups in 1.5 liters? Use
// Foundation’s `Measurement` types to figure it out.
let oneAndHalfLiters = Measurement(value: 1.5, unit: UnitVolume.liters)
let cups = oneAndHalfLiters.converted(to: UnitVolume.cups)

print("There are \(cups) in \(oneAndHalfLiters)")

// 3. Create an initializer for `Quadrant` that takes
// a polar coordinate.

extension Quadrant {
  init?(_ polar: Polar) {
    self.init(Point(polar))
  }
}
