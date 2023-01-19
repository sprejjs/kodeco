//
// Created by Allan Spreys on 19/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import Foundation

public struct MoveCommand {
  public var gameboard: Gameboard
  public var player: Player
  public var position: GameboardPosition
  public var gameboardView: GameboardView

  public func execute(completion: (()->Void)? = nil) {
    gameboard.setPlayer(player, at: position)
    gameboardView.placeMarkView(
      player.markViewPrototype.copy(),
      at: position,
      animated: true,
      completion: completion)
  }
}
