/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

protocol Incrementable {
  mutating func increment(by value: Int)
}

example("Protocol conformance") {
  struct MyStruct: Incrementable {
    mutating func increment(by value: Int) {
    }
  }
}

struct MyStruct2 {}
extension MyStruct2: Incrementable {
  mutating func increment(by value: Int) {
  }
}

extension Int: Incrementable {
  mutating func increment(by value: Int) {
    self += value
  }
}

final class ClassInt {
  private var storage: Int
  init(_ value: Int) {
    self.storage = value
  }

  var value: Int {
    get { self.storage }
    set { storage = newValue }
  }
}

enum EnumInt: Int {
  case test
}

extension EnumInt: Incrementable {
  mutating func increment(by value: Int) {
    self = EnumInt(rawValue: rawValue + value) ?? self
  }
}

extension ClassInt: Incrementable {
  func increment(by value: Int) {
    storage += value
  }
}

extension ClassInt: CustomStringConvertible {
  var description: String {
    "\(storage)"
  }
}

var incrementable: Incrementable = 25 // <- Assigning Int to a variable that's of type `Incrementable`
print(incrementable) // <- This is fine
incrementable = ClassInt(21) // Re-assigning a completely different type to the variable as long
// as it also conforms to Incrementable
print(incrementable) // <- This is fine

var myArray: [Incrementable] = [] // <- Array of elements conforming to `incrementable`
myArray.append(2) // <- Adding an Int
myArray.append(ClassInt(25)) // <- Adding a class Int

for i in myArray.indices { // <- Iterating over indices of the array
  myArray[i].increment(by: 10) // <- Calling `increment` on each element of the array
}

print(myArray)

protocol MyShinyProtocol {
  var getterOnlyVariable: Int { get }
}

struct ComputerProperty: MyShinyProtocol {
  var getterOnlyVariable: Int {
    return 6
  }
}

struct ConstantProperty: MyShinyProtocol {
  let getterOnlyVariable: Int = 5
}

struct PrivateSetProperty: MyShinyProtocol {
  private(set) var getterOnlyVariable: Int = 5
}

struct InternalVariable: MyShinyProtocol {
  var getterOnlyVariable: Int = 6
}

var myVariable = InternalVariable()
myVariable.getterOnlyVariable = 2 // <- ✅ We are accessing the property
// through InternalVariable type
var myVariable2: MyShinyProtocol = myVariable
//myVariable2.getterOnlyVariable = 5 // <- ❎ error: cannot assign to property:
// 'getterOnlyVariable' is a get-only property

protocol ProtocolWithStatic {
  static func myStaticFunc()
  static var supportedLanguages: [String] { get }
}

protocol ParentProtocol {
  func implementFunc()
}

protocol ChildProtocol: ParentProtocol { // <- Inherits from `ParentProtocol`
  var implementVar: Int { get }
}

struct MyStruct: ChildProtocol {
  var implementVar: Int // <- Required by ChildProtocol

  func implementFunc() { // <- Required by ParentProtocol
  }
}

protocol MyProtocol {
  mutating func myFunction()
}

example("mutating func") {
  struct MyStruct: MyProtocol {
    mutating func myFunction() {} // <- Has to be mutating
  }

  class MyClass: MyProtocol {
    func myFunction() {} // <- Mutating implicitly
  }
}

protocol ProtocolWithDefault {
  var meaningOfLife: Int { get }
}

extension ProtocolWithDefault {
  var meaningOfLife: Int { 42 }
}

struct NoMeaning: ProtocolWithDefault {
  var meaningOfLife: Int { 0 }
}

struct DefaultMeaning: ProtocolWithDefault {}

var noMeaning = NoMeaning()
print(noMeaning.meaningOfLife) // <- Prints 0

var defaultMeaning = DefaultMeaning()
print(defaultMeaning.meaningOfLife) // <- Prints 42

protocol ClassOnlyProtocol: AnyObject {
}

final class MyClass: ClassOnlyProtocol {
}

//struct MyStruct: ClassOnlyProtocol { // <- ❎ non-class type 'MyStruct' cannot conform to class protocol 'ClassOnlyProtocol'
//}

import UIKit

protocol ForUIControlsOnly where Self: UIControl {
}

extension UIButton: ForUIControlsOnly { // <- ✅ This is fine
}

//extension MyClass: ForUIControlsOnly { // <- error: ❎ 'ForUIControlsOnly' requires that 'MyClass' inherit from 'UIControl'
//}

class MyCustomClass {
  final func helloWorld() {

  }
}

protocol SimpleProtocol {
  func simpleMethod()
}

func executeSimpleMethod(on protocolInstance: SimpleProtocol) {
  protocolInstance.simpleMethod()
}

protocol Greetable {
  func greet() -> String
}

extension Greetable {
  func greet() -> String {
    return "Hello"
  }

  func leave() -> String {
    return "Bye"
  }
}

struct GermanGreeter: Greetable {
  func greet() -> String {
    return "Hallo"
  }

  func leave() -> String {
    return "Tschüss"
  }
}

let greeter: Greetable = GermanGreeter() // Using `Greetable` variable type
print(greeter.greet()) // <- Prints `Hallo` from `GermanGreeter`.
print(greeter.leave()) // <- Prints `Bye` from `Greetable` extension

let greeter2: GermanGreeter = GermanGreeter() // Using `GermanGreeter` type
print(greeter2.greet()) // <- Prints `Hallo` from `GermanGreeter`.
print(greeter2.leave()) // <- Prints `Tschüss` from `Greetable` extension

protocol Localizable {

}

func localizedGreet(with greeter: Greetable & Localizable & CustomStringConvertible) {
}

var myType: (Greetable & Localizable & CustomStringConvertible)?

extension Greetable where Self: Localizable, Self: CustomStringConvertible {

}

// @frozen struct Array<Element>

extension Array where Element: Greetable {
  var allGreetings: String {
    self.map { $0.greet() }.joined()
  }
}

protocol SomeProtocol {
  func someMethod() -> String
}

protocol AnotherProtocol {
  func anotherMethod() -> String
}

struct StructA: SomeProtocol, AnotherProtocol {
  func someMethod() -> String {
    "I am struct A"
  }

  func anotherMethod() -> String {
    "I am struct A"
  }
}

struct StructB: SomeProtocol, AnotherProtocol {
  func someMethod() -> String {
    "I am struct B"
  }

  func anotherMethod() -> String {
    "I am struct A"
  }
}

extension Array where Element: SomeProtocol {
  func printSome() {
    self.forEach {
      print($0.someMethod())
    }
  }
}

extension Array where Element: SomeProtocol & AnotherProtocol {
  func printSomeAndAnother() {
    self.forEach {
      print($0.someMethod())
      print($0.anotherMethod())
    }
  }
}

let structA = StructA()
let structB = StructB()

//let test: [any SomeProtocol] = [structA, structB]
//test.printSome()
//test.printSomeAndAnother()

[StructA(), StructA(), StructA()].printSomeAndAnother()

extension Array: Greetable where Element: Greetable {
  static func greetableOnArray() -> String {
    "Return from the whole array"
  }
}

struct Preference<T> {
  var value: T?
}

extension Preference {
  mutating func save(from untypedValue: Any) {
    if let value = untypedValue as? T {
      self.value = value
    }
  }
}

extension Preference where T: Decodable { // <- Will only apply if T is Decodable
  mutating func save(from json: Data) throws {
    let decoder = JSONDecoder()
    self.value = try decoder.decode(T.self, from: json)
  }
}

extension Preference {
  mutating func save2(from json: Data) throws where T: Decodable{
    let decoder = JSONDecoder()
    self.value = try decoder.decode(T.self, from: json)
  }
}

protocol Networker {}

class WebsocketNetworker: Networker {
  class func whoAmI() -> Networker.Type {
    return self
  }

  func whoAmI() -> Networker.Type {
    return Self.self
  }
}

let type: Networker.Type = WebsocketNetworker.whoAmI()
print(type) // <- WebsocketNetworker

let websocket = WebsocketNetworker()
print(websocket.whoAmI()) // <- WebsocketNetworker

