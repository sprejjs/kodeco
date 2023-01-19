//
// Created by Allan Spreys on 19/1/2023.
// Copyright (c) 2023 Joshua Greene. All rights reserved.
//

import Foundation

public protocol DecryptionHandlerProtocol {
  var next: DecryptionHandlerProtocol? { get }
  func decrypt(data encryptedData: Data) -> String?
}
