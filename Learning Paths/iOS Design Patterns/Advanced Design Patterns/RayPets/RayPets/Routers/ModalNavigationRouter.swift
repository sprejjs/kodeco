//
// Created by Allan Spreys on 21/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import UIKit

public final class ModalNavigationRouter: NSObject {
  public unowned let parentViewController: UIViewController
  private let navigationController = UINavigationController()
  private var onDismissForViewController: [UIViewController: () -> Void] = [:]

  public init(parentViewController: UIViewController) {
    self.parentViewController = parentViewController
    super.init()
    navigationController.delegate = self
  }
}

extension ModalNavigationRouter: Router {
  public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
    onDismissForViewController[viewController] = onDismissed

    if navigationController.viewControllers.isEmpty {
      addCancelButton(to: viewController)
      navigationController.viewControllers = [viewController]
      parentViewController.present(navigationController, animated: animated)
    } else {
      navigationController.pushViewController(viewController, animated: animated)
    }
  }

  public func dismiss(animated: Bool) {
    guard let viewController = navigationController.viewControllers.first else {
      return
    }
    onDismissForViewController[viewController]?()
    onDismissForViewController[viewController] = nil
    parentViewController.dismiss(animated: true)
  }

  private func addCancelButton(to viewController: UIViewController) {
    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .cancel,
        target: self,
        action: #selector(cancelButtonTapped)
    )
  }

  @objc private func cancelButtonTapped() {
    dismiss(animated: true)
    parentViewController.dismiss(animated: true)
  }
}

extension ModalNavigationRouter: UINavigationControllerDelegate {
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    guard
      let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
      !navigationController.viewControllers.contains(fromViewController)
    else {
      return
    }

    onDismissForViewController[fromViewController]?()
    onDismissForViewController[fromViewController] = nil
  }
}
