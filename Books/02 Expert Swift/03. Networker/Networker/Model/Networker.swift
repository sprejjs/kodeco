//
// Created by Allan Spreys on 13/2/2023.
// Copyright (c) 2023 Ray Wenderlich. All rights reserved.
//

import Foundation
import Combine
import UIKit

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

protocol Networking {
  var delegate: NetworkingDelegate? { get set }

  func fetch<R: Request>(_ request: R) -> AnyPublisher<R.Output, Error>
  func fetchWithCache<R: Request>(_ request: R)
    -> AnyPublisher<R.Output, Error> where R.Output == UIImage
}

final class Networker: Networking {
  private let jsonDecoder = JSONDecoder()
  private let imageCache = RequestCache<UIImage>()

  weak var delegate: NetworkingDelegate?

  func fetchWithCache<R: Request>(_ request: R)
    -> AnyPublisher<R.Output, Error> where R.Output == UIImage {
    if let response = imageCache.response(for: request) {
      return Just<R.Output>(response)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    return fetch(request)
        .handleEvents(receiveOutput: { [weak self] in
          self?.imageCache.saveResponse(for: request, response: $0)
        })
        .eraseToAnyPublisher()
  }

  func fetch<R: Request>(_ request: R) -> AnyPublisher<R.Output, Error> {
    let method = request.method.rawValue

    var urlRequest = URLRequest(url: request.url)
    urlRequest.allHTTPHeaderFields = delegate?.headers(for: self)
    urlRequest.httpMethod = method

    var publisher = URLSession.shared
      .dataTaskPublisher(for: urlRequest)
      .map(\.data)
      .eraseToAnyPublisher()

    if let delegate {
      publisher = delegate
        .networking(self, transformPublisher: publisher)
    }

    return publisher
      .tryMap(request.decode)
      .eraseToAnyPublisher()
  }
}
