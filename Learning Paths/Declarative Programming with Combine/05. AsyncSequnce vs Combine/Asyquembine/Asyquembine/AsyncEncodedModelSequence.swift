//
//  AsyncEncodedModelSequence.swift
//  Asyquembine
//
//  Created by Allan Spreys on 9/2/2023.
//

import Foundation
import Combine

final class AsyncEncodedModelSequence {
  let syncIterator = EncodedModelIterator()

  private var cancellable: AnyCancellable = AnyCancellable(){}
  private var continuation: CheckedContinuation<Data?, Error>?

  init() {
    cancellable = syncIterator
      .publisher
      .sink(receiveCompletion: { [unowned self] completion in
        switch completion {
        case .finished:
          continuation?.resume(returning: nil)
        case .failure(let error):
          continuation?.resume(throwing: error)
        }
      }, receiveValue: { [unowned self] value in
        continuation?.resume(returning: value)
      })
  }
}

extension AsyncEncodedModelSequence: AsyncSequence, AsyncIteratorProtocol {
  typealias Element = Data

  func next() async throws -> Data? {
    try await withCheckedThrowingContinuation { contiuation in
      self.continuation = contiuation
    }
  }
}

extension AsyncSequence where AsyncIterator == Self {
  func makeAsyncIterator() -> Self { self }
}
