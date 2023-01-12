/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Prototype
 - - - - - - - - - -
 ![Prototype Diagram](Prototype_Diagram.png)
 
 The prototype pattern is a creational pattern that allows an object to copy itself. It involves two types:
 
 1. A **copying** protocol declares copy methods.
 
 2. A **prototype** is a class that conforms to the copying protocol.
 
 ## Code Example
 */


public class User: Copying {
  public var name: String

  init(name: String) {
    self.name = name
  }

  public required convenience init(_ prototype: User) {
    self.init(name: prototype.name)
  }
}

var array1 = [User(name: "Interesting subject")]
// The assignment uses shallow copy
var array2 = array1

array1[0].name = "The name has changed!"
print(array2[0].name) // Outputs `The name has changed!`

public protocol Copying: AnyObject {
  init(_ prototype: Self)
}

extension Copying {
  public func copy() -> Self {
    return type(of: self).init(self)
  }
}

extension Sequence where Element: Copying {
  public func deepCopy() -> [Element] {
    map { $0.copy() }
  }
}

public final class LastnameUser: User {
  public var lastname: String

  public init(name: String, lastname: String) {
    self.lastname = lastname
    super.init(name: name)
  }

  @available(*, unavailable) // Ensures the method is not called directly
  public required convenience init(_ prototype: User) {
    guard let prototype = prototype as? LastnameUser else {
      fatalError("Wrong prototype type")
    }
    self.init(name: prototype.name, lastname: prototype.lastname)
  }
}

var array3 = array2.deepCopy()
array1[0].name = "The name has changed again!"

print("Value in array 1: \(array1[0].name)" ) // Outputs `The name has changed again!`
print("Value in array 2: \(array2[0].name)" ) // Outputs `The name has changed again!`
print("Value in array 3: \(array3[0].name)" ) // Outputs `The name has changed!`
