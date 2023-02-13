//
// Created by Allan Spreys on 13/2/2023.
// Copyright (c) 2023 Ray Wenderlich. All rights reserved.
//

import Foundation

struct ImageRequest: Request {
  let url: URL
  let method: HTTPMethod = .get
}
