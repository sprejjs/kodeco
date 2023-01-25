// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

let owlBear = RWMonster(name: "Owl Bear", hitPoints: 30)
var enemies: [RWMonster] = [owlBear]
owlBear.hitPoints += 10
print(enemies)  // 40, not 30.  Reference semantics :[

final class SwiftReference<T> {
  var object: T
  init(_ object: T) {
    self.object = object
  }
}

struct Monster: CustomStringConvertible {
  private var _monster: SwiftReference<RWMonster>

  private var _mutatingMonster: RWMonster {
    mutating get {
      if !isKnownUniquelyReferenced(&_monster) {
        print("Making a copy")
        _monster = SwiftReference(_monster.object.copy() as! RWMonster)
      } else {
        print("No copy")
      }
      return _monster.object
    }
  }

  init(name: String, hitPoints: Int) {
    self._monster = .init(.init(name: name, hitPoints: hitPoints))
  }

  var description: String {
    "Monster \(_monster.object.name) has \(_monster.object.hitPoints)hp"
  }

  var name: String {
    get {
      return _monster.object.name
    }
    set {
      _mutatingMonster.name = newValue
    }
  }

  var hitPoints: Int {
    get { _monster.object.hitPoints }
    set { _mutatingMonster.hitPoints = newValue }
  }
}

var monster = Monster(name: "Tomtom", hitPoints: 25)
var array = [monster]
monster.hitPoints -= 5 // Changing the hit points on the original reference did not affect the value stored in the array because we have implemented copy on write.
print(array[0])
