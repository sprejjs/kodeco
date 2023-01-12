//
// Created by Allan Spreys on 10/1/2023.
// Copyright (c) 2023 Jay Strawn. All rights reserved.
//

import Foundation

import MapKit
import YelpAPI

public enum AnnotationFactory {
  public static func createBusinessMapView(for business: Business) -> BusinessMapViewModel {
    let name = business.name
    let rating = business.rating
    let image: UIImage
    switch rating {
    case 0..<3:
      image = UIImage(named: "terrible")!
    case 3..<3.5:
      image = UIImage(named: "bad")!
    case 3.5..<4.0:
      image = UIImage(named: "meh")!
    case 4.0..<4.75:
      image = UIImage(named: "good")!
    case 4.75...5.0:
      image = UIImage(named: "great")!
    default:
      image = UIImage(named: "bad")!
    }

    return BusinessMapViewModel(coordinate: business.location,
        name: name,
        rating: rating,
        image: image)
  }
}
