/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Mediator
 - - - - - - - - - -
 ![Mediator Diagram](Mediator_Diagram.png)
 
 The mediator pattern is a behavioral design pattern that encapsulates how objects communicate with one another. It involves four types:
 
 1. The **colleagues** are the objects that want to communicate with each other. They implement the colleague protocol.
 
 2. The **colleague protocol** defines methods and properties that each colleague must implement.
 
 3. The **mediator** is the object that controls the communication of the colleagues. It implements the mediator protocol.
 
 4. The **mediator protocol** defines methods and properties that the mediator must implement.
 
 ## Code Example
 */

// MARK - Colleague Protocol
public protocol Colleague: AnyObject {
  func colleague(_ colleague: Colleague?, didReceive message: String)
}

// MARK - Mediator Protocol
public protocol MediatorProtocol: AnyObject {
  func addColleague(_ colleague: Colleague)
  func send(message: String, from colleague: Colleague)
}

// MARK: - Colleague

public class Musketeer {
  public let name: String
  public weak var mediator: MediatorProtocol?

  public init(name: String, mediator: MediatorProtocol) {
    self.name = name
    self.mediator = mediator
    mediator.addColleague(self)
  }

  public func sendMessage(_ message: String) {
    print("\(name) sends: \(message)")
    mediator?.send(message: message, from: self)
  }
}

extension Musketeer: Colleague {
  public func colleague(_ colleague: Colleague?, didReceive message: String) {
    print("\(name) received: \(message)")
  }
}

// MARK: - Mediator
public class MusketeerMediator: Mediator<Colleague> {
}

extension MusketeerMediator: MediatorProtocol {
  public func addColleague(_ colleague: Colleague) {
    addColleague(colleague, strongReference: true)
  }

  public func send(message: String, from colleague: Colleague) {
    invokeColleagues(by: colleague) {
      $0.colleague(colleague, didReceive: message)
    }
  }
}

// MARK: - Usage Example
let mediator = MusketeerMediator()

let aramis = Musketeer(name: "Aramis", mediator: mediator)
let athos = Musketeer(name: "Athos", mediator: mediator)
let porthos = Musketeer(name: "Porthos", mediator: mediator)

aramis.sendMessage("All for one, and one for all!")

mediator.invokeColleagues { $0.colleague(nil, didReceive: "Charge!") }
