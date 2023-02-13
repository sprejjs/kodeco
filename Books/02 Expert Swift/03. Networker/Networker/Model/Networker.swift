//
// Created by Allan Spreys on 13/2/2023.
// Copyright (c) 2023 Ray Wenderlich. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol Networking {
  var delegate: NetworkingDelegate? { get set }

  func fetch(_ request: Request) -> AnyPublisher<Data, URLError>
}

protocol NetworkingDelegate: AnyObject {
  func headers(for networking: Networking) -> [String: String]

  func networking(
    _ networking: Networking,
    transformPublisher: AnyPublisher<Data, URLError>
  ) -> AnyPublisher<Data, URLError>
}

extension NetworkingDelegate {
  func headers(for networking: Networking) -> [String: String] {
    [:]
  }

  func networking(
    _ networking: Networking,
    transformPublisher publisher: AnyPublisher<Data, URLError>
  ) -> AnyPublisher<Data, URLError> {
    publisher
  }
}

final class Networker: Networking {
  weak var delegate: NetworkingDelegate?

  func fetch(_ request: Request) -> AnyPublisher<Data, URLError> {
    let method = request.method.rawValue

    var request = URLRequest(url: request.url)
    request.allHTTPHeaderFields = delegate?.headers(for: self)
    request.httpMethod = method

    let publisher = URLSession.shared
      .dataTaskPublisher(for: request)
      .map(\.data)
      .eraseToAnyPublisher()

    if let delegate {
      return delegate.networking(self, transformPublisher: publisher)
    } else {
      return publisher
    }
  }
}
