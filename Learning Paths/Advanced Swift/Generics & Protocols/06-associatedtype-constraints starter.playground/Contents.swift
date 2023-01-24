// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

protocol Distribution {
  associatedtype Value: Numeric
  func sample<G: RandomNumberGenerator>(using generator: inout G) -> Value
  func sample<G>(count: Int, using generator: inout G) -> [Value] where G: RandomNumberGenerator
}

extension Distribution {
  func sample<G>(count: Int, using generator: inout G) -> [Value] where G: RandomNumberGenerator {
    var g = SystemRandomNumberGenerator()
    return (1...count).map { _ in sample(using: &g) }
  }
  
  func sample() -> Value {
    var g = SystemRandomNumberGenerator()
    return sample(using: &g)
  }
  
  func sample(count: Int) -> [Value] {
    var g = SystemRandomNumberGenerator()
    return sample(count: count, using: &g)
  }
}

//////////////////////////////////////////////////////////////////////


let distros = [BinomialDistribution(p: 0.1),
               BinomialDistribution(p: 0.5),
               BinomialDistribution(p: 0.9)]

let sum = distros.sumOfSamples()
type(of: sum)

extension Sequence where Element: Distribution {
  func sumOfSamples() -> Element.Value {
    reduce(0) { $0 + $1.sample() }
  }
}

//////////////////////////////////////////////////////////////////////

struct UniformDistribution: Distribution {
  
  var range: Range<Int>

  init<R: RangeExpression>(range expr: R) where R.Bound == Int {
    range = expr.relative(to: Range<Int>(Int.min...Int.max-1))
  }
    
  func sample<G: RandomNumberGenerator>(using generator: inout G) -> Int {
    return Int.random(in: range)
  }
}

struct BinomialDistribution: Distribution {
  let probability: Double
  var q: Double {
    1 - probability
  }

  init(p: Double) {
    precondition(p >= 0 && p <= 1, "p must be between 0 and 1")
    self.probability = p
  }

  func sample<G: RandomNumberGenerator>(using generator: inout G) -> Int {
    Double.random(in: 0...1, using: &generator) <= probability ? 1 : 0
  }
}

let coin = BinomialDistribution(p: 0.5)
coin.sample(count: 100)

UniformDistribution(range: 0...10).sample()
UniformDistribution(range: 0..<11).sample()


