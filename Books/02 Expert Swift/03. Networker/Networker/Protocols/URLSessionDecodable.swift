//
// Created by Allan Spreys on 13/2/2023.
// Copyright (c) 2023 Ray Wenderlich. All rights reserved.
//

import Foundation

protocol URLSessionDecodable {
  init(from output: Data) throws
}

extension Array: URLSessionDecodable where Element == Article {
  init(from output: Data) throws {
    self = try JSONDecoder().decode(Articles.self, from: output).data.map { $0.article }
  }
}
