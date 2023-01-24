// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

protocol Distribution {
  associatedtype Value
  
  func sample() -> Value
  func sample<G: RandomNumberGenerator>(generator: inout G) -> Value
  func sample(count: Int) -> [Value]
}

extension Distribution {
  
  func sample(count: Int) -> [Value] {
    return (1...count).map { _ in sample() }
  }
}

//////////////////////////////////////////////////////////////////////

struct UniformDistribution: Distribution {
  
  var range: ClosedRange<Int>
  
  func sample() -> Int {
    var generator = SystemRandomNumberGenerator()
    return sample(generator: &generator)
  }

  func sample<G: RandomNumberGenerator>(generator: inout G) -> Int {
    return Int.random(in: range, using: &generator)
  }
}

let d6 = UniformDistribution(range: 1...6)
d6.sample()
