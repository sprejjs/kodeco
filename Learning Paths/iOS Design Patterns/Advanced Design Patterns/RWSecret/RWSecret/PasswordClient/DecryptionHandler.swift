//
// Created by Allan Spreys on 19/1/2023.
// Copyright (c) 2023 Joshua Greene. All rights reserved.
//

import RNCryptor

public final class DecryptionHandler {
  public var next: DecryptionHandlerProtocol?
  public let password: String
  public init(password: String) {
    self.password = password
  }
}

extension DecryptionHandler: DecryptionHandlerProtocol {
  public func decrypt(data encryptedData: Data) -> String? {
    if let decryptedData = try? RNCryptor.decrypt(data: encryptedData, withPassword: password) {
      return String(data: decryptedData, encoding: .utf8)
    }

    return next?.decrypt(data: encryptedData)
  }
}
