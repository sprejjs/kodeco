//
// Created by Allan Spreys on 10/1/2023.
// Copyright (c) 2023 Jay Strawn. All rights reserved.
//

import CoreLocation

public protocol BusinessSearchClient {
  func search(
      with coordinate: CLLocationCoordinate2D,
      term: String,
      limit: UInt,
      offset: UInt,
      success: @escaping ([Business]) -> Void,
      failure: @escaping (Error?) -> Void)
}
