//
// Created by Allan Spreys on 13/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import UIKit

public final class CopyState: DrawViewState {
  public override func copyLines(from source: DrawView) {
    drawView.layer.sublayers?.removeAll()
    drawView.lines = source.lines.deepCopy()
    drawView.lines.forEach { drawView.layer.addSublayer($0) }
    transitionToState(matching: AcceptInputState.identifier)
  }
}
