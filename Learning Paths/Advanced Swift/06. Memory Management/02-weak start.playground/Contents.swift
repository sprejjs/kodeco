// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

do {
  CelestialBody("Skylab")
}

class Star: CelestialBody {
  var planets: [Planet]

  init(_ name: String, planets: [Planet]) {
    self.planets = planets
    super.init(name)
    self.planets.forEach {
      $0.system = self
    }
  }
}

class Planet: CelestialBody {
  weak var system: Star?
}

do {
  let names = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
  let planets = names.map { Planet($0) }
  let sun = Star("Sun", planets: planets)
  print(sun.name, "is alive!")
}
