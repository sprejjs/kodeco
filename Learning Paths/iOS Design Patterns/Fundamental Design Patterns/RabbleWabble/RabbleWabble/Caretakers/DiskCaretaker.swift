//
// Created by Allan Spreys on 8/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import Foundation

public final class DiskCaretaker {
  public static let shared = DiskCaretaker()
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  private let documentsDirectory: URL

  private init() {
    documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }

  public func save<T: Codable>(_ object: T, to fileName: String) throws {
    do {
      let url = documentsDirectory.appendingPathComponent(fileName)
      let data = try encoder.encode(object)
      try data.write(to: url, options: .atomic)
    } catch (let error) {
      assertionFailure(error.localizedDescription)
      throw error
    }
  }

  public func load<T: Codable>(_ fileName: String) throws -> T {
    do {
      let url = documentsDirectory.appendingPathComponent(fileName)
      let data = try Data(contentsOf: url)
      return try decoder.decode(T.self, from: data)
    } catch (let error) {
      throw error
    }
  }

  public func load<T: Codable>(_ url: URL) throws -> T {
    do {
      let data = try Data(contentsOf: url)
      return try decoder.decode(T.self, from: data)
    } catch (let error) {
      assertionFailure(error.localizedDescription)
      throw error
    }
  }
}