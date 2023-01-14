/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Facade
 - - - - - - - - - -
 ![Multicast Delegate Diagram](Facade_Diagram.png)
 
 The facade pattern is a structural pattern that provides a simple interface to a complex system. It involves two types:
 
 1. The **facade** provides simple methods to interact with the system. This allows consumers to use the facade instead of knowing about and interacting with multiple classes in the system.
 
 2. The **dependencies** are objects owned by the facade. Each dependency performs a small part of a complex task.
 
 ## Code Example
 */

// MARK: - Dependencies (Models)
public struct Customer {
  public let identifier: String
  public var address: String
  public var name: String
}

extension Customer: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  public static func == (lhs: Customer, rhs: Customer) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}

public struct Product {
  public let identifier: String
  public var name: String
  public var price: Double
}

extension Product: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  public static func == (lhs: Product, rhs: Product) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}

// MARK: Dependencies (Services)
public class InventoryDatabase {
  public var inventory: [Product: Int] = [:]

  public init(_ inventory: [Product: Int]) {
    self.inventory = inventory
  }
}

public class ShippingDatabase {
  public var pendingShipments: [Customer: [Product]] = [:]
}

// MARK: - Facade
public class OrderFacade {
  private let inventoryDatabase: InventoryDatabase
  private let shippingDatabase: ShippingDatabase

  public init(inventoryDatabase: InventoryDatabase, shippingDatabase: ShippingDatabase) {
    self.inventoryDatabase = inventoryDatabase
    self.shippingDatabase = shippingDatabase
  }

  public func placeOrder(customer: Customer, product: Product, quantity: Int) {
    print("Placing order for \(quantity) \(product.name) by \(customer.name)")

    guard inventoryDatabase.inventory[product] ?? 0 >= quantity else {
      print("Not enough inventory to place order")
      return
    }

    inventoryDatabase.inventory[product]! -= quantity

    var shipments = shippingDatabase.pendingShipments[customer] ?? []
    shipments.append(product)
    shippingDatabase.pendingShipments[customer] = shipments

    print("Order placed for \(quantity) \(product.name) by \(customer.name)")
  }
}

// MARK: - Usage
let inventoryDatabase = InventoryDatabase([Product(identifier: "1", name: "MacBook Pro", price: 2_000): 10])
let shippingDatabase = ShippingDatabase()
let orderFacade = OrderFacade(inventoryDatabase: inventoryDatabase, shippingDatabase: shippingDatabase)

let customer = Customer(identifier: "1", address: "123 Main St", name: "John Doe")
let product = Product(identifier: "1", name: "MacBook Pro", price: 2_000)

orderFacade.placeOrder(customer: customer, product: product, quantity: 5)
orderFacade.placeOrder(customer: customer, product: product, quantity: 5)
orderFacade.placeOrder(customer: customer, product: product, quantity: 5)
