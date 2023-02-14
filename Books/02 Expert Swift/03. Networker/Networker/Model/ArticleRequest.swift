//
// Created by Allan Spreys on 13/2/2023.
// Copyright (c) 2023 Ray Wenderlich. All rights reserved.
//

import Foundation

struct ArticleRequest: Request {
  typealias Output = [Article]

  let url: URL = {
    guard var components = URLComponents(string: "https://api.raywenderlich.com/") else {
      fatalError("Unable to create URLComponents")
    }
    components.path = "/api/contents"
    components.queryItems = [
      URLQueryItem(name: "filter[content_types][]", value: "article"),
    ]

    guard let url = components.url else {
      fatalError("Unable to create URL from components")
    }
    return url
  }()

  let method: HTTPMethod = .get

  func decode(_ data: Data) throws -> [Article] {
    try JSONDecoder().decode(Articles.self, from: data).data.map { $0.article }
  }
}
