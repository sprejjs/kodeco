// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.


// This should work:
// let aboutThree = 3.0 +/- 0.5
// aboutThree.contains(2.7)

infix operator +/-: RangeFormationPrecedence

@inlinable func +/-<T: FloatingPoint> (lhs: T, rhs: T) -> ClosedRange<T> {
  let positive = abs(rhs)
  return ClosedRange(uncheckedBounds: (lower: lhs - positive, upper: lhs + positive))
}

let aboutThree: ClosedRange<Float> = 3.0 +/- 0.5
aboutThree.contains(2.7)
