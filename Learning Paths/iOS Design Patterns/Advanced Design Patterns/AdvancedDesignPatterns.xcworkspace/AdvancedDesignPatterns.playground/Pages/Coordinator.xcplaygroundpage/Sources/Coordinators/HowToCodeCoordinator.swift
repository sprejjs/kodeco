/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

public class HowToCodeCoordinator {
  public var children: [Coordinator] = []
  public let router: Router

  private lazy var stepViewControllers = [
    StepViewController.instantiate(delegate: self, buttonColor: .systemRed, text: "Step 1", title: "Step 1"),
    StepViewController.instantiate(delegate: self, buttonColor: .systemBlue, text: "Step 2", title: "Step 2"),
    StepViewController.instantiate(delegate: self, buttonColor: .systemGreen, text: "Step 3", title: "Step 3"),
    StepViewController.instantiate(delegate: self, buttonColor: .systemOrange, text: "Step 4", title: "Step 4"),
  ]

  private lazy var startOverviewController = StartOverViewController.instantiate(delegate: self)

  public init(router: Router) {
    self.router = router
  }
}

extension HowToCodeCoordinator: Coordinator {
  public func present(animated: Bool, onDismissed: (() -> Void)?) {
    router.present(stepViewControllers[0], animated: animated, completion: onDismissed)
  }
}

extension HowToCodeCoordinator: StepViewControllerDelegate {
  public func stepViewControllerDidPressNext(_ stepViewController: StepViewController) {
    guard let index = stepViewControllers.firstIndex(of: stepViewController) else { return }
    if index == stepViewControllers.count - 1 {
      router.present(startOverviewController, animated: true)
    } else {
      router.present(stepViewControllers[index + 1], animated: true)
    }
  }
}

extension HowToCodeCoordinator: StartOverViewControllerDelegate {
  public func startOverViewControllerDidPressStartOver(_ startOverViewController: StartOverViewController) {
    router.dismiss(animated: true)
  }
}
