// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

do {
  let tycho = Supernova("Tycho")
  tycho.explode()
  print(tycho.name)
}

class Supernova: CelestialBody {
  lazy var explode: () -> Void = { [unowned self] in
    self.name = "BOOMED \(self.name)"
  }
}

do {
  let kepler = Supernova("Kepler")
  DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { // <- Dispatch queue strongly captures kepler, but kepler is not referencing dispatch queue, so there is no cycle
    kepler.explode()
    print(kepler.name)
  }
}

//do {
//  let galileo = Supernova("Galileo")
//  DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [unowned galileo] in // <- This would cause a crash because nothing is storing a reference to
//    // Gelileo once the scope is over
//    galileo.explode()
//    print(galileo.name)
//  }
//}

do {
  let galileo = Supernova("Galileo")
  DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak galileo] in // <- Storing the weak reference and the ensuring that it is still available allows
    // the closure to be executed, but doesn't crash the code because we ensure that the variable is still there before calling a function on it.
    guard let galileo else {
      return
    }
    galileo.explode()
    print(galileo.name)
  }
}
