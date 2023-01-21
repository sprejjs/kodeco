//
// Created by Allan Spreys on 20/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import Foundation

public final class HomeCoordinator: Coordinator {
  public var children: [Coordinator] = []
  public private(set) var router: Router

  public init(router: Router) {
    self.router = router
  }

  public func present(animated: Bool, onDismissed: (() -> ())?) {
    let viewController = HomeViewController.instantiate(delegate: self)
    router.present(viewController, animated: animated, onDismissed: onDismissed)
  }
}

extension HomeCoordinator: HomeViewControllerDelegate {
  public func homeViewControllerDidPressScheduleAppointment(_ viewController: HomeViewController) {
    let coordinator = PetAppointmentBuilderCoordinator(router: ModalNavigationRouter(parentViewController: viewController))
    presentChild(coordinator, animated: true)
  }
}
