/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Multicast Delegate
 - - - - - - - - - -
 ![Multicast Delegate Diagram](MulticastDelegate_Diagram.png)
 
 The multicast delegate pattern is a behavioral pattern and a variation on the delegate pattern. Instead of a one-to-one delegate relationship, the multicast delegate allows you to create one-to-many delegate relationships. It involes three types:
 
 1. The **delegate protocol** defines the methods a delegate may or should implement.
 2. The **delegate** is an object that implements the delegate protocol.
 3. The **Multicast Delegate** is a helper class that holds onto delegates and allows you to invoke _all_ of the delegates whenever a delegate-worthy event happens.
 
 ## Code Example
 */

import UIKit

// MARK: - Delegate Protocol
public protocol EmergencyResponding {
  func notifyFire(at location: String)
  func notifyCarCrash(at location: String)
}

// MARK: - Delegates
public class FireStation: EmergencyResponding {
  public func notifyFire(at location: String) {
    print("Fire Station: Fire at \(location)!")
  }

  public func notifyCarCrash(at location: String) {
    print("Fire Station: Car crash at \(location)!")
  }
}

public class PoliceStation: EmergencyResponding {
  public func notifyFire(at location: String) {
    print("Police Station: Fire at \(location)!")
  }

  public func notifyCarCrash(at location: String) {
    print("Police Station: Car crash at \(location)!")
  }
}

// MARK: - Delegating Object
public class DispatchSystem {
  let multicastDelegate = MulticastDelegate<EmergencyResponding>()
}

// MARK: - Example
let dispatchSystem = DispatchSystem()
var fireStation: FireStation! = FireStation()
var policeStation = PoliceStation()

dispatchSystem.multicastDelegate.addDelegate(fireStation)
dispatchSystem.multicastDelegate.addDelegate(policeStation)

dispatchSystem.multicastDelegate.invokeDelegates { $0.notifyFire(at: "123 Main St.") }

print("")

fireStation = nil
dispatchSystem.multicastDelegate.invokeDelegates { $0.notifyCarCrash(at: "123 Main St.") }
