//
// Created by Allan Spreys on 13/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import UIKit

public final class AcceptInputState: DrawViewState {
  public override func animate() {
    transitionToState(matching: AnimateState.identifier).animate()
  }

  public override func clear() {
    transitionToState(matching: ClearState.identifier).clear()
  }

  public override func copyLines(from source: DrawView) {
    transitionToState(matching: CopyState.identifier).copyLines(from: source)
  }

  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let point = touches.first?.location(in: drawView) else { return }
    let line = LineShape(color: drawView.lineColor, width: drawView.lineWidth, startPoint: point)
    addLine(line)

    drawView.multicastDelegate.invokeDelegates {
      $0.drawView(drawView, didAddLine: line)
    }
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard
      let point = touches.first?.location(in: drawView),
      drawView.bounds.contains(point)
    else { return }

    addPoint(point)

    drawView.multicastDelegate.invokeDelegates {
      $0.drawView(drawView, didAddPoint: point)
    }
  }

  private func addLine(_ line: LineShape) {
    drawView.lines.append(line)
    drawView.layer.addSublayer(line)
  }

  private func addPoint(_ point: CGPoint) {
    drawView.lines.last?.addPoint(point)
  }
}

extension AcceptInputState {
  public override func drawView(_ drawView: DrawView, didAddPoint point: CGPoint) {
    addPoint(point)
  }

  public override func drawView(_ drawView: DrawView, didAddLine line: LineShape) {
    let newLine = line.copy() as LineShape
    addLine(newLine)
  }
}
