/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Observer
 - - - - - - - - - -
 ![Observer Diagram](Observer_Diagram.png)
 
 The observer pattern allows "observer" objects to register for and receive updates whenever changes are made to "subject" objects.
 
 This pattern allows us to define "one-to-many" relationships between many observers receiving updates from the same subject.
 
 ## Code Example
 */

import Combine

@available(iOS 13, *)
final public class User {
  @Published public var name: String

  public init(name: String) {
    self.name = name
  }
}

let user = User(name: "John")
let publisher = user.$name

var subscriber: AnyCancellable? = publisher.sink { name in
  print("User's name is \(name)")
}

user.name = "Jane"

subscriber = nil
user.name = "Ray has left the building" // This doesn't get printed into console.