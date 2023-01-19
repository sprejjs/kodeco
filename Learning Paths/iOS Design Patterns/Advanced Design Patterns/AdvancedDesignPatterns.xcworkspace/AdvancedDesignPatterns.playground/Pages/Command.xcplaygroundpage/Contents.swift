/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Command
 - - - - - - - - - -
 ![Command Diagram](Command_Diagram.png)
 
 The command pattern is a behavioral pattern that encapsulates information to perform an action into a "command object." It involves three types:
 
 1. The **invoker** stores and executes commands.
 2. The **command** encapsulates the action as an object.
 3. The **receiver** is the object that's acted upon by the command.
 
 ## Code Example
 */

import Foundation

public class Door {
  public var isOpen = false
}

public class DoorCommand {
  public let door: Door

  public init(door: Door) {
    self.door = door
  }

  public func execute() {}
}

public class OpenDoorCommand: DoorCommand {
  public override func execute() {
    print("Opening the door...")
    door.isOpen = true
  }
}

public class CloseCommand: DoorCommand {
  public override func execute() {
    print("Closing the door...")
    door.isOpen = false
  }
}

// MAR: - Invoker
public class Doorman {
  public let commands: [DoorCommand]
  public let door: Door

  init(door: Door) {
    self.commands = (0..<Int.random(in: 1...10)).map { _ in
      return Bool.random() ? OpenDoorCommand(door: door) : CloseCommand(door: door)
    }
    self.door = door
  }

  public func executeCommands() {
    print("The doorman is...")
    commands.forEach { $0.execute() }
  }
}

let door = Door()
let doorman = Doorman(door: door)
doorman.executeCommands()
