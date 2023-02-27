//
//  ColorAttributeTransformer.swift
//  BowTies
//
//  Created by Allan Spreys on 26/02/2023.
//  Copyright © 2023 Razeware. All rights reserved.
//

import UIKit

final class ColorAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
  override class var allowedTopLevelClasses: [AnyClass] {
    [UIColor.self]
  }

  static func register() {
    let className = String(describing: ColorAttributeTransformer.self)
    let name = NSValueTransformerName(className)

    let transformer = ColorAttributeTransformer()
    ValueTransformer.setValueTransformer(transformer, forName: name)
  }
}
