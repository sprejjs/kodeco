/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

let eAcute = "\u{E9}"
let combinedEAcute = "\u{65}\u{301}"
print(eAcute) // é
print(combinedEAcute) // é

print(eAcute == combinedEAcute) // true

let eAcute_objC: NSString = "\u{E9}"
let combinedEAcute_objC: NSString = "\u{65}\u{301}"

eAcute_objC.length // 1
combinedEAcute_objC.length // 2

eAcute_objC == combinedEAcute_objC // false


let acute = "\u{301}"
let smallE = "\u{65}"

acute.count // 1
smallE.count // 1

let combinedEAcute2 = smallE + acute // é

combinedEAcute2.count // 1


"A".lengthOfBytes(using: .utf8) // 1
"Ф".lengthOfBytes(using: .utf8) // 2
"水".lengthOfBytes(using: .utf8) // 3
"🙈".lengthOfBytes(using: .utf8) // 4

let originalString = "H̾e͜l͘l͘ò W͛òr̠l͘d͐!"
originalString.contains("Hello") // false

let foldedString = originalString.folding(
  options: [.caseInsensitive, .diacriticInsensitive],
  locale: .current)
foldedString.contains("hello") // true

originalString.localizedStandardContains("hello") // true

struct Book {
  var name: String
  var authors: [String]
  var fpe: String
}

extension Book: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    let parts = value.components(separatedBy: " by: ")
    let bookName = parts.first ?? ""
    let authorNames = parts.last?.components(separatedBy: ",") ?? []
    self.name = bookName
    self.authors = authorNames
    self.fpe = ""
  }
}

extension Book: ExpressibleByStringInterpolation { // 1
  struct StringInterpolation: StringInterpolationProtocol { // 2
    var name: String // 3
    var authors: [String]
    var fpe: String

    init(literalCapacity: Int, interpolationCount: Int) { // 4
      name = ""
      authors = []
      fpe = ""
    }

    mutating func appendLiteral(_ literal: String) { // 5
      // Do something with the literals?
    }

    mutating func appendInterpolation(_ name: String) { // 6
      self.name = name
    }

    mutating func appendInterpolation(
      authors list: [String]) { // 7
      authors = list
    }
  }

  init(stringInterpolation: StringInterpolation) { // 8
    self.authors = stringInterpolation.authors
    self.name = stringInterpolation.name
    self.fpe = stringInterpolation.fpe
  }
}

struct Friends: ExpressibleByStringInterpolation {
  typealias StringLiteralType = String

  struct StringInterpolation: StringInterpolationProtocol {

    var friendA: String = ""
    var friendB: String = ""

    init(literalCapacity: Int, interpolationCount: Int) {
    }

    mutating func appendLiteral(_ literal: String) {
    }

    mutating func appendInterpolation(friendA: String) {
      self.friendA = friendA
    }

    mutating func appendInterpolation(friendB: String) {
      self.friendB = friendB
    }
  }

  let friendA: String
  let friendB: String

  init(stringInterpolation: StringInterpolation) {
    friendA = stringInterpolation.friendA
    friendB = stringInterpolation.friendB
  }

  init(stringLiteral value: String) {
    friendA = ""
    friendB = ""
  }
}

var friends: Friends = "\(friendA: "Bonny") and \(friendB: "Clyde") are friends."
print(friends)

struct Friend: ExpressibleByStringLiteral {
  let name: String
  init(stringLiteral value: StringLiteralType) {
    self.name = value
  }
}

let friend: Friend = "Jordan"
print(friend) // "Friend(name: "Jordan")\n"
