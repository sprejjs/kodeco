//
// Created by Allan Spreys on 20/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import UIKit

public final class AppDelegateRouter: Router {
  public let window: UIWindow

  public init(window: UIWindow) {
    self.window = window
  }

  public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
    window.rootViewController = viewController
    window.makeKeyAndVisible()
  }

  public func dismiss(animated: Bool) {
    // don't do anything
  }
}
