//
// Created by Allan Spreys on 12/1/2023.
// Copyright (c) 2023 Jay Strawn. All rights reserved.
//

public struct Filter {
  public let filter: (Business) -> Bool
  public var businesses: [Business] = []

  public static func identity() -> Filter {
    Filter(filter: { _ in true })
  }

  public static func starRating(atLeast rating: Double) -> Filter {
    Filter(filter: { $0.rating >= rating })
  }

  public func filterBusinesses() -> [Business] {
    businesses.filter(filter)
  }
}

extension Filter: Sequence {
  public func makeIterator() -> IndexingIterator<[Business]> {
    filterBusinesses().makeIterator()
  }
}
