//
// Created by Allan Spreys on 12/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import Foundation

public protocol Copying {
  init(_ prototype: Self)
}
extension Copying {
  public func copy() -> Self {
    type(of: self).init(self)
  }
}

extension Sequence where Element: Copying {
  public func deepCopy() -> [Element] {
    map { $0.copy() }
  }
}
