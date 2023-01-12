//
// Created by Allan Spreys on 10/1/2023.
// Copyright (c) 2023 Jay Strawn. All rights reserved.
//

import CoreLocation
import YelpAPI

extension YLPClient: BusinessSearchClient {
  public func search(
      with coordinate: CLLocationCoordinate2D,
      term: String,
      limit: UInt,
      offset: UInt,
      success: @escaping ([Business]) -> Void,
      failure: @escaping (Error?) -> Void) {

    let yelpCoordinate = YLPCoordinate(latitude: coordinate.latitude,
        longitude: coordinate.longitude)

    search(with: yelpCoordinate, term: term, limit: limit, offset: offset, sort: .bestMatched) { (searchResult, error) in
      guard let searchResult = searchResult,
            error == nil
      else {
        failure(error)
        return
      }

      success(searchResult.businesses.adaptToBusiness())
    }
  }
}

extension Array where Element: YLPBusiness {
  func adaptToBusiness() -> [Business] {
    compactMap { yelpBusiness in
      guard let yelpCoordinate = yelpBusiness.location.coordinate else {
        return nil
      }
      let coordinate = CLLocationCoordinate2D(latitude: yelpCoordinate.latitude,
          longitude: yelpCoordinate.longitude)
      return Business(name: yelpBusiness.name,
          rating: yelpBusiness.rating,
          location: coordinate)
    }
  }
}
