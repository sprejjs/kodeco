// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

struct Email: Equatable {
  private (set) var address: String

  init?(_ raw: String) {
    guard raw.contains("@") else {
      return nil
    }
    address = raw
  }
}

class User: Equatable {
  var id: Int?
  var name: String
  var email: Email
  
  init(id: Int?, name: String, email: Email) {
    self.id = id
    self.name = name
    self.email = email
  }

  static func == (lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.email == rhs.email
  }
}

guard let email = Email("ray@example.com") else {
  fatalError("not a valid email")
}

let user1 = User(id: nil, name: "Ray", email: email)
let user2 = User(id: nil, name: "Ray", email: email)
let user3 = user1

user1 == user2 // true -> The two objects are equal
user1 === user2 // false -> The two references are pointing to different objects
user1 === user3 // true -> The two references are pointing to the same object
