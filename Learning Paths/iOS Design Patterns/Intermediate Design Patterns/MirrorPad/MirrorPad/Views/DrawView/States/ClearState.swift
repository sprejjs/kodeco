//
// Created by Allan Spreys on 13/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import UIKit

public final class ClearState: DrawViewState {
  public override func clear() {
    drawView.lines = []
    drawView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    transitionToState(matching: AcceptInputState.identifier)
  }
}
