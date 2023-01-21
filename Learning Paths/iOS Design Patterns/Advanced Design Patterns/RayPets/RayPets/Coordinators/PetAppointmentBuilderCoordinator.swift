//
// Created by Allan Spreys on 20/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import UIKit

public final class PetAppointmentBuilderCoordinator: Coordinator {
  public let builder = PetAppointmentBuilder()
  public var children: [Coordinator] = []
  public private(set) var router: Router

  public init(router: Router) {
    self.router = router
  }

  public func present(animated: Bool, onDismissed: (() -> ())?) {
    let viewController = SelectVisitTypeViewController.instantiate(delegate: self)
    router.present(viewController, animated: animated, onDismissed: onDismissed)
  }
}

extension PetAppointmentBuilderCoordinator: SelectVisitTypeViewControllerDelegate {
  public func selectVisitTypeViewController(
      _ controller: SelectVisitTypeViewController,
      didSelect visitType: VisitType
  ) {
    builder.visitType = visitType

    let viewController: UIViewController
    switch visitType {
    case .well:
      viewController = NoAppointmentRequiredViewController.instantiate(delegate: self)
    case .sick:
      viewController = SelectPainLevelViewController.instantiate(delegate: self)
    }
    router.present(viewController, animated: true)
  }
}

extension PetAppointmentBuilderCoordinator: NoAppointmentRequiredViewControllerDelegate {
  public func noAppointmentViewControllerDidPressOkay(_ controller: NoAppointmentRequiredViewController) {
    router.dismiss(animated: true)
  }
}

extension PetAppointmentBuilderCoordinator: SelectPainLevelViewControllerDelegate {
  public func selectPainLevelViewController(_ controller: SelectPainLevelViewController, didSelect painLevel: PainLevel) {
    builder.painLevel = painLevel

    let viewController: UIViewController
    switch painLevel {
    case .none, .little:
      viewController = FakingItViewController.instantiate(delegate: self)
    case .moderate, .severe, .worstPossible:
      viewController = NoAppointmentRequiredViewController.instantiate(delegate: self)
    }

    router.present(viewController, animated: true)
  }
}

extension PetAppointmentBuilderCoordinator: FakingItViewControllerDelegate {
  public func fakingItViewControllerPressedIsFake(_ controller: FakingItViewController) {
    router.dismiss(animated: true)
  }

  public func fakingItViewControllerPressedNotFake(_ controller: FakingItViewController) {
    let viewController = NoAppointmentRequiredViewController.instantiate(delegate: self)
    router.present(viewController, animated: true)
  }
}
