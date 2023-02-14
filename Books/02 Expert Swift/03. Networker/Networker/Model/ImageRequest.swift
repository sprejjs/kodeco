//
// Created by Allan Spreys on 13/2/2023.
// Copyright (c) 2023 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit

struct ImageRequest: Request {
  typealias Output = UIImage

  let url: URL
  let method: HTTPMethod = .get

  func decode(_ data: Data) throws -> UIImage {
    guard let image = UIImage(data: data) else {
      throw DecodingError.unableToDecodeImage
    }

    return image
  }
}

enum DecodingError: Error {
  case unableToDecodeImage
}
