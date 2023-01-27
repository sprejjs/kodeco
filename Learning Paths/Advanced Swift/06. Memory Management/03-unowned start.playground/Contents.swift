// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

class Star: CelestialBody {
  var planets: [Planet] = []
}

class Planet: CelestialBody {
  unowned let system: Star
  init(_ name: String, system: Star) {
    self.system = system
    super.init(name)
  }
}

var planetGlobal: Planet?
do {
  let sun = Star("Sun")
  let earth = Planet("Earth", system: sun)
  sun.planets.append(earth)
  print("\(sun.name) is alive!")
  planetGlobal = earth
}
print(planetGlobal?.system.name)
