// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

public extension File {
  // Challenge 1
  
  // Rewind the file to the beginning.
  // Hint: use seek(to:)
  
  func rewind() throws {
    try self.seek(to: .init(offset: .zero))
  }
  
  // Challenge 2
  // Get the size of the file.
  // Hint: use fseek(file, 0, SEEK_END) and ftell(file)
  
  func size() throws -> Int {
    guard let file = file else {
      throw FileError.notOpen
    }
    let pos = try position()
    if fseek(file, 0, SEEK_END) != 0 {
      throw FileError.seek
    }
    let result = ftell(file)
    try seek(to: pos)

    return result
  }
}

/* Test code for you to try out your code with */

func test() {
  // Open a file and write to it
  do {
    let file = try FileSystem.default.open(filepath: "Hello.txt", for: .writing)
    for i in 1...3 {
      try file.put("Hello, World 🌎 \(i)\n")
    }
    file.close()
  }
  catch {
    print(error)
  }
  
  // Open the file, get it's size.
  do {
    let file = try FileSystem.default.open(filepath: "Hello.txt", for: .readingAndWriting)
    print("Size:", (try? file.size()) ?? "Unknown")
    for line in file.lines() {
      print(line, terminator: "")
    }
    
    // Rewind and read it a second time
    print("Reading a second time...")
    try file.rewind()
    for line in file.lines() {
      print(line, terminator: "")
    }
  }
  catch {
    print("failed: \(error)")
  }
}
test()
