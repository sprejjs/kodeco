/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Memento
 - - - - - - - - - -
 ![Memento Diagram](Memento_Diagram.png)
 
 The memento pattern allows an object to be saved and restored. It involves three parts:
 
 (1) The **originator** is the object to be saved or restored.
 
 (2) The **memento** is a stored state.
 
 (3) The **caretaker** requests a save from the originator, and it receives a memento in response. The care taker is responsible for persisting the memento, so later on, the care taker can provide the memento back to the originator to request the originator restore its state.
 
 ## Code Example
 */

import UIKit

// MARK: - Originator

public final class Game: Codable {
  public class State: Codable {
    public var attemptsRemaining: Int = 3
    public var level: Int = 1
    public var score: Int = 0
  }

  public var state = State()

  public func rackUpMassivePoints() {
    state.score += 1000
  }

  public func monsterEatPlayer() {
    state.attemptsRemaining -= 1
  }
}

// MARK: - Memento
typealias GameMemento = Data

// MARK: - Caretaker

public final class GameSystem {
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  private let userDefaults = UserDefaults.standard

  public func save(_ game: Game, title: String) throws {
    let memento = try encoder.encode(game)
    userDefaults.set(memento, forKey: title)
  }

  public func load(title: String) throws -> Game {
    guard let memento = userDefaults.data(forKey: title),
     let game = try? decoder.decode(Game.self, from: memento) else {
      throw Error.mementoNotFound
    }

    return game
  }

  public enum Error: Swift.Error {
    case mementoNotFound
  }
}

// MARK: - Example

var game = Game()
game.monsterEatPlayer()
game.rackUpMassivePoints()

// Save the game
let gameSystem = GameSystem()
try gameSystem.save(game, title: "My Game")

// New game
game = Game()
print("New Game Score: \(game.state.score)")

// Load the game
let loadedGame = try gameSystem.load(title: "My Game")
print("Score: \(loadedGame.state.score)")
