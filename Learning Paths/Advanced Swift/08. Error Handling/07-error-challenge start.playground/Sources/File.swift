// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

// A simple file abstraction built on top of C standard io.
// See http://www.cplusplus.com/reference/cstdio/

public enum FileError: Error {
  case missingRootDirectory
  case open(String)
  case notOpen
  case get(ferror: Int32)
  case stringDecode(Data)
  case position(errno: Int32)
  case eof
  case unableToWrite
  case seek
  case size
}

// A file can be opened and closed.
public class File {
  public enum Mode: String {
    case reading = "r",
    writing = "w",
    appending = "a",
    readingAndWriting = "r+",
    writingAndReading = "w+"
  }
  
  // The File and mode
  public let filename: String
  public let mode: Mode
  
  // underlying FILE
  public var file: UnsafeMutablePointer<FILE>?
  
  // Opens the file on initialization and throws if it cannot.
  public init(filename: String, mode: Mode) throws {
    self.filename = filename
    self.mode = mode
    
    try filename.withCString { f in
      try mode.rawValue.withCString { m in
        file = fopen(f, m)
        if file == nil {
          throw FileError.open(filename)
        }
      }
    }
  }
  
  // Close the file and set it to nil
  public func close() {
    guard let file = file else {
      return
    }
    fclose(file)
    self.file = nil
  }
  
  deinit {
    close()
  }
}

// Positioning API
extension File {
  // A simple types that encapsulates position
  public struct Position {
    public init(offset: Int64) { self.offset = offset }
    var offset: Int64
  }
  
  // Get the position of the file
  public func position() throws -> Position {
    guard let file = file else {
      throw FileError.notOpen
    }
    var pos: fpos_t = 0
    if fgetpos(file, &pos) != 0 {
      throw FileError.position(errno: errno)
    }
    return Position(offset: pos)
  }
  
  // Set the position of the file.
  public func seek(to position: Position) throws {
    guard let file = file else {
      throw FileError.notOpen
    }
    var pos: fpos_t =  position.offset
    try withUnsafePointer(to: &pos) { posPointer in
      if fsetpos(file, posPointer) != 0 {
        throw FileError.seek
      }
    }
  }
}

// A interface for getting and putting strings into a file.
extension File {
  
  // Put a string into the file at the current position
  @discardableResult
  public func put(_ message: String) throws -> Int {
    guard let file = file else {
      throw FileError.notOpen
    }
    
    let written = message.withCString { bytes in
      Int(fputs(bytes, file))
    }
    if written != message.utf8.count {
      throw FileError.unableToWrite
    }
    return written
  }
  
  // Get a line from the file or maxLineLength, whichever comes first.
  public func get(_ maxLineLength: Int = 4096) throws -> String {
    guard let file = file else {
      throw FileError.notOpen
    }
    let bytes = UnsafeMutablePointer<Int8>.allocate(capacity: maxLineLength)
    defer {
      bytes.deallocate()
    }
    
    fgets(bytes, Int32(maxLineLength), file)
    
    let error = ferror(file)
    if error != 0 {
      throw FileError.get(ferror: error)
    }
    
    if feof(file) != 0 {
      clearerr(file)
      throw FileError.eof
    }
    
    var readCount = 0
    for byte in UnsafeBufferPointer(start: bytes, count: maxLineLength) {
      readCount += 1
      if byte == 0 {
        break
      }
    }
    
    var backoffCount: Int64 = 0
    var data = Data(bytesNoCopy: bytes, count: readCount, deallocator: .none)
    
    // To handle UTF8 boundaries properly attempt to decode the string.
    // if that fails, it is probably that you have not read in all of the
    // bytes that you need to. If possible back off by a byte and see
    // if the string can be decoded.
    //
    // This will handle most cases, but fails when a single character
    // exceeds the size of the original read buffer.
    
    while true {
      if let decoded = String(data: data, encoding: .utf8) {
        if backoffCount > 0 {
          let pos = try position()
          try seek(to: Position(offset: pos.offset-backoffCount+1))
        }
        return decoded
      }
      else {
        if data.count > 0 {
          data.count -= 1
          backoffCount += 1
        }
        if data.count > 0 {
          data.count = readCount
          throw FileError.stringDecode(data)
        }
      }
    }
  }
}

// Create an extension to treat a file like a sequence

extension File {
  public struct LineReader: Sequence {
    
    var file: File
    var maxLineLength: Int
    
    init(file: File, maxLineLength: Int) {
      self.file = file
      self.maxLineLength = maxLineLength
    }
    
    public func makeIterator() -> AnyIterator<String> {
      return AnyIterator {
        try? self.file.get(self.maxLineLength)
      }
    }
  }
  
  public func lines(maxLineLength: Int = 4096) -> LineReader {
    return LineReader(file: self, maxLineLength: maxLineLength)
  }
}

// FileSystem is an API that handles adds a root to the sandbox of your files.

public struct FileSystem {
  var root = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
  
  // Convenience singleton
  public static var `default` = FileSystem()
  
  public func open(filepath: String, for mode: File.Mode) throws -> File {
    guard let root = root else {
      throw FileError.missingRootDirectory
    }
    let filepathWithRoot = root + "/" + filepath
    return try File(filename: filepathWithRoot, mode: mode)
  }
}

