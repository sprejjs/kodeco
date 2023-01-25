// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

struct Email: Hashable {
  init?(_ raw: String) {
    guard raw.contains("@") else {
      return nil
    }
    address = raw
  }
  
  private(set) var address: String
}

class User: Hashable {
  var id: Int?
  var name: String
  var email: Email
  
  init(id: Int?, name: String, email: Email) {
    self.id = id
    self.name = name
    self.email = email
  }
  
  static func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id &&
      lhs.name == rhs.name &&
      lhs.email == rhs.email
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
    hasher.combine(email)
  }
}

class Test: Hashable {
  var value: String
  init(_ value: String) {
    self.value = value
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine("Hello world") // In this example the `hash` function returns a static value, so each object will have the same hash causing collisions
  }

  static func == (lhs: Test, rhs: Test) -> Bool {
    return lhs.value == rhs.value // However, the equality function implementation is accurate, so even though there is a hash collision, multiple objects can be stored with the same hash key. That being said the more objects with the same hash there are the slower the collection will be as it will need to reiterate through each object at that key until the correct value is found.
  }
}


let object1 = Test("Foo")
let object2 = Test("Bar")
var dictionary: [Test: String] = [:]
dictionary[object1] = object1.value
dictionary[object2] = object2.value
print(dictionary)
