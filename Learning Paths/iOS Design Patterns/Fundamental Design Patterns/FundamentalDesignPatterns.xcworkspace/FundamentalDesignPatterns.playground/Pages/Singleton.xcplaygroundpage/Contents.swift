/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Singleton
 - - - - - - - - - -
 ![Singleton Diagram](Singleton_Diagram.png)
 
 The singleton pattern restricts a class to have only _one_ instance.
 
 The "singleton plus" pattern is also common, which provides a "shared" singleton instance, but it also allows other instances to be created too.
 
 ## Code Example
 */

import UIKit

// MARK: - Singleton

let app = UIApplication.shared // Shared instance
//let app2 = UIApplication() // New instance that crashes the app. UIApplication only allows a single instance.

public final class MySingleton {
  static let shared = MySingleton() // Shared instance
  private init() {} // Prevents others from creating their own instances
}

let mySingleton = MySingleton.shared
//let mySingleton2 = MySingleton() // Doesn't compile. MySingleton's initializer is private.

// MARK: - Singleton Plus
let defaultFileManager = FileManager.default // Shared instance
let customFileManager = FileManager() // New instance

public final class MySingletonPlus {
  static let shared = MySingletonPlus() // Shared instance
  public init() {} // Allows others to create their own instances
}

let mySingletonPlus = MySingletonPlus.shared
let mySingletonPlus2 = MySingletonPlus()