/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # State
 - - - - - - - - - -
 ![State Diagram](State_Diagram.png)
 
 The state pattern is a behavioral pattern that allows an object to change its behavior at runtime. It does so by changing an internal state. This pattern involves three types:
 
 1. The **context** is the object whose behavior changes and has an internal state.
 
 2. The **state protocol** defines a set of methods and properties required by concrete states. If you need stored properties, you can substitute a **base state class** instead of a protocol.
 
 3. The **concrete states** conform to the state protocol, or if a base class is used instead, they subclass the base. They implement required methods and properties to perform whatever behavior is desired when the context is in its state.
 
 ## Code Example
 */

import UIKit
import PlaygroundSupport

// MARK: - Context
@available(iOS 3, *)
public class TrafficLight: UIView {
  public private(set) var canisterLayers: [CAShapeLayer] = []
  public private(set) var currentState: TrafficLightState
  public private(set) var states: [TrafficLightState]

  public var nextState: TrafficLightState {
    guard
      let index = states.firstIndex(where: { $0 === currentState }),
      index + 1 < states.count
    else {
      return states[0]
    }

    return states[index + 1]
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError()
  }

  public init(
    canisterCount: Int = 3,
    frame: CGRect = CGRect(x: 0, y: 0, width: 160, height: 420),
    states: [TrafficLightState]
  ) {
    guard !states.isEmpty else {
      fatalError("You must provide at least one state.")
    }
    self.currentState = states[0]
    self.states = states
    super.init(frame: frame)
    backgroundColor = UIColor(red: 0.86, green: 0.64, blue: 0.25, alpha: 1)
    createCanisterLayers(count: canisterCount)
    transition(to: currentState)
  }

  private func createCanisterLayers(count: Int) {
    let paddingPercentage: CGFloat = 0.2
    let yTotalPadding = paddingPercentage * bounds.height
    let yPadding = yTotalPadding / CGFloat(count + 1)

    let canisterHeight = (bounds.height - yTotalPadding) / CGFloat(count)
    let xPadding = (bounds.width - canisterHeight) / 2.0
    var canisterFrame = CGRect(x: xPadding, y: yPadding,
                              width: canisterHeight, height: canisterHeight)

    for _ in 0 ..< count {
      let canisterShape = CAShapeLayer()
      canisterShape.path = UIBezierPath(ovalIn: canisterFrame).cgPath
      canisterShape.fillColor = UIColor.black.cgColor
      layer.addSublayer(canisterShape)
      canisterLayers.append(canisterShape)
      canisterFrame.origin.y += (canisterFrame.height + yPadding)
    }
  }

  public func transition(to state: TrafficLightState) {
    removeCanisterSublayers()
    currentState = state
    currentState.apply(to: self)
    nextState.apply(to: self, after: currentState.delay)
  }

  public func removeCanisterSublayers() {
    canisterLayers.forEach { $0.sublayers?.forEach { $0.removeFromSuperlayer() } }
  }
}

// MARK: - State Protocol
@available(iOS 3, *)
public protocol TrafficLightState: AnyObject {
  var delay: TimeInterval { get }

  func apply(to context: TrafficLight)
}

 // MARK: - Concrete States
@available(iOS 3, *)
public class SolidTrafficLightState {
  public let canisterIndex: Int
  public let color: UIColor
  public let delay: TimeInterval

  public init(canisterIndex: Int,
              color: UIColor,
              delay: TimeInterval) {
    self.canisterIndex = canisterIndex
    self.color = color
    self.delay = delay
  }
}

extension TrafficLightState {
  public func apply(to context: TrafficLight, after delay: TimeInterval) {
    let queue = DispatchQueue.main
    let dispatchTime = DispatchTime.now() + delay
    queue.asyncAfter(deadline: dispatchTime) { [weak self, weak context] in
      guard let self, let context else { return }

      context.transition(to: self)
    }
  }
}

extension SolidTrafficLightState: TrafficLightState {
  public func apply(to context: TrafficLight) {
    let canisterLayer = context.canisterLayers[self.canisterIndex]
    let circleShape = CAShapeLayer()
    circleShape.path = canisterLayer.path!
    circleShape.fillColor = color.cgColor
    circleShape.strokeColor = color.cgColor
    canisterLayer.addSublayer(circleShape)
  }
}

extension SolidTrafficLightState {
  public class func greenLight(
    canisterIndex: Int = 2,
    color: UIColor = UIColor(red: 0.21, green: 0.78, blue: 0.35, alpha: 1.0),
    delay: TimeInterval = 1.0
  ) -> SolidTrafficLightState {
    return SolidTrafficLightState(canisterIndex: canisterIndex, color: color, delay: delay)
  }

  public class func yellowLight(
    canisterIndex: Int = 1,
    color: UIColor = UIColor(red: 0.98, green: 0.91, blue: 0.07, alpha: 1.0),
    delay: TimeInterval = 1.0
  ) -> SolidTrafficLightState {
    return SolidTrafficLightState(canisterIndex: canisterIndex, color: color, delay: delay)
  }

  public class func redLight(
    canisterIndex: Int = 0,
    color: UIColor = UIColor(red: 0.88, green: 0.0, blue: 0.04, alpha: 1.0),
    delay: TimeInterval = 1.0
  ) -> SolidTrafficLightState {
    return SolidTrafficLightState(canisterIndex: canisterIndex, color: color, delay: delay)
  }
}

let states: [SolidTrafficLightState] = [
  .redLight(),
  .yellowLight(),
  .greenLight(),
]

PlaygroundPage.current.liveView = TrafficLight(states: states)
