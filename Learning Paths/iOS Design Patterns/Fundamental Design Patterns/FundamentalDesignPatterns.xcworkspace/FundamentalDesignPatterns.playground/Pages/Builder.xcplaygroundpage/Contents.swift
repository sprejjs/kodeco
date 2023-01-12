/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Builder
 - - - - - - - - - -
 ![Builder Diagram](Builder_Diagram.png)
 
 The builder pattern allows complex objects to be created step-by-step instead of all-at-once via a large initializer.
 
 The builder pattern involves three parts:
 
 (1) The **product** is the complex object to be created.
 
 (2) The **builder** accepts inputs step-by-step and ultimately creates the product.
 
 (3) The **director** supplies the builder with step-by-step inputs and requests the builder create the product once everything has been provided.
 
 ## Code Example
 */

import Foundation

// MARK: - Product
public struct Hamburger {
  public let meat: Meat
  public let sauce: Sauces
  public let toppings: Toppings
}

extension Hamburger: CustomStringConvertible {
  public var description: String {
    return "Hamburger with \(meat), \(sauce), and \(toppings)"
  }
}

public enum Meat: String {
  case beef
  case chicken
  case turkey
}

public struct Sauces: OptionSet {
  public let rawValue: Int
  public init(rawValue: Int) { self.rawValue = rawValue }

  public static let ketchup = Sauces(rawValue: 1 << 0)
  public static let mustard = Sauces(rawValue: 1 << 1)
  public static let mayo = Sauces(rawValue: 1 << 2)
}

public struct Toppings: OptionSet {
  public let rawValue: Int
  public init(rawValue: Int) { self.rawValue = rawValue }

  public static let lettuce = Toppings(rawValue: 1 << 0)
  public static let tomato = Toppings(rawValue: 1 << 1)
  public static let onion = Toppings(rawValue: 1 << 2)
  public static let pickle = Toppings(rawValue: 1 << 3)
}

// MARK: - Builder
public final class HamburgerBuilder {
  public private(set) var meat: Meat = .beef
  public private(set) var sauces: Sauces = []
  public private(set) var toppings: Toppings = []

  private var soldOutMeats: [Meat] = [.chicken]

  private enum Error: Swift.Error {
    case soldOut
  }

  public func setMeat(_ meat: Meat) throws {
    guard !soldOutMeats.contains(meat) else {
      throw Error.soldOut
    }
    self.meat = meat
  }

  public func addSauces(_ sauces: Sauces) {
    self.sauces.insert(sauces)
  }

  public func removeSauces(_ sauces: Sauces) {
    self.sauces.remove(sauces)
  }

  public func addToppings(_ toppings: Toppings) {
    self.toppings.insert(toppings)
  }

  public func removeToppings(_ toppings: Toppings) {
    self.toppings.remove(toppings)
  }

  public func build() -> Hamburger {
    return Hamburger(meat: meat, sauce: sauces, toppings: toppings)
  }
}

// MARK: - Director

public final class Employee {
  public func createCombo1() throws -> Hamburger {
    let builder = HamburgerBuilder()
    try builder.setMeat(.beef)
    builder.addSauces([.ketchup, .mustard])
    builder.addSauces(.mustard)
    builder.addToppings(.lettuce)
    builder.addToppings(.tomato)
    return builder.build()
  }

  public func createChickenBurger() throws -> Hamburger {
    let builder = HamburgerBuilder()
    try builder.setMeat(.chicken)
    builder.addSauces([.ketchup, .mustard])
    builder.addToppings(.lettuce)
    builder.addToppings(.tomato)
    return builder.build()
  }
}

enum GenericError: Error {
  case unknown
}

var employee = Employee()
guard let hamburger = try? employee.createCombo1() else { throw GenericError.unknown }
print(hamburger)

if let chicken = try? employee.createChickenBurger() {
  print(chicken)
} else {
  print("Sorry, can't do")
}
