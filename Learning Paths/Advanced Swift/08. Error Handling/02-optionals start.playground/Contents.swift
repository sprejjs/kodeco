// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

struct Email {

  init?(raw: String) {
    guard Email.isValid(raw) else {
      return nil
    }
    self.address = raw
  }

  init(_ address: StaticString) {
    let address = address.withUTF8Buffer {
      String(decoding: $0, as: UTF8.self)
    }
    precondition(Email.isValid(address), "invalid email")
    self.address = address
  }

  
  
  // Is valid regex by https://stackoverflow.com/a/26503188/591884
  static func isValid(_ input: String) -> Bool {

    // Why is try! okay here?
    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)

    return regex.firstMatch(in: input, options: [], range:
      NSRange(location: 0, length: input.count)) != nil
  }
  
  var address: String
}

Email(raw: "asdf") // return nil
Email("valid@email.com") // returns an instance
var value = "some value"
//Email(value) // Doesn't compile
