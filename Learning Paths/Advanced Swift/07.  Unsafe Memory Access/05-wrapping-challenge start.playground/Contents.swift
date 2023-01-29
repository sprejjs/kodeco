// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation
import Compression

enum CompressionAlgorithm {
  case lz4   // speed is critical
  case lz4a  // space is critical
  case zlib  // reasonable speed and space
  case lzfse // better speed and space
}

enum CompressionOperation {
  case compression, decompression
}

// return compressed or uncompressed data depending on the operation
func perform(_ operation: CompressionOperation,
             on input: Data,
             using algorithm: CompressionAlgorithm,
             workingBufferSize: Int = 2000) -> Data?  {
  
  // set the algorithm
  let streamAlgorithm: compression_algorithm
  switch algorithm {
  case .lz4:   streamAlgorithm = COMPRESSION_LZ4
  case .lz4a:  streamAlgorithm = COMPRESSION_LZMA
  case .zlib:  streamAlgorithm = COMPRESSION_ZLIB
  case .lzfse: streamAlgorithm = COMPRESSION_LZFSE
  }
  
  // set the stream operation and flags
  let streamOperation: compression_stream_operation
  let flags: Int32
  switch operation {
  case .compression:
    streamOperation = COMPRESSION_STREAM_ENCODE
    flags = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)
  case .decompression:
    streamOperation = COMPRESSION_STREAM_DECODE
    flags = 0
  }
  
  // TBD: Compression
  var streamPointer = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
  defer {
    streamPointer.deallocate()
  }

  var stream = streamPointer.pointee
  var status = compression_stream_init(&stream, streamOperation, streamAlgorithm)
  guard status != COMPRESSION_STATUS_ERROR else {
    return nil
  }
  defer {
    compression_stream_destroy(&stream)
  }

  let dstSize = workingBufferSize
  let dstPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: dstSize)
  defer {
    dstPointer.deallocate()
  }
  return input.withUnsafeBytes { srcPointer in
    var output = Data()

    stream.src_ptr = srcPointer.baseAddress!.bindMemory(to: UInt8.self, capacity: input.count)
    stream.src_size = input.count
    stream.dst_ptr = dstPointer
    stream.dst_size = dstSize

    while status == COMPRESSION_STATUS_OK {
      status = compression_stream_process(&stream, flags)

      switch status {
      case COMPRESSION_STATUS_OK:
        output.append(dstPointer, count: dstSize)
        stream.dst_ptr = dstPointer
        stream.dst_size = dstSize
      case COMPRESSION_STATUS_ERROR:
        return nil
      case COMPRESSION_STATUS_END:
        output.append(dstPointer, count: stream.dst_ptr - dstPointer)
      default:
        fatalError()
      }
    }

    return output
  }
}

struct Compressed {
  
  let data: Data
  let algorithm: CompressionAlgorithm
  
  init(data: Data, algorithm: CompressionAlgorithm) {
    self.data = data
    self.algorithm = algorithm
  }
  
  // Compress the input with the specified algorithm. Returns nil if it fails.
  static func compress(input: Data,
                       with algorithm: CompressionAlgorithm) -> Compressed? {
    guard let data = perform(.compression, on: input, using: algorithm) else {
      return nil
    }
    return Compressed(data: data, algorithm: algorithm)
  }
  
  // Uncompressed data. Returns nil if the data cannot be decompressed.
  func decompressed() -> Data? {
    return perform(.decompression, on: data, using: algorithm)
  }
}

// For discoverability, add a compressed method to Data
extension Data {
  
  // Returns compressed data or nil if compression fails.
  func compressed(with algorithm: CompressionAlgorithm) -> Compressed? {
    return Compressed.compress(input: self, with: algorithm)
  }
  
}

// Example usage:

let input = Data(Array(repeating: UInt8(123), count: 10000))

let compressed = input.compressed(with: .lzfse)
compressed?.data.count // in most cases much less than orginal input count

let restoredInput = compressed?.decompressed()
input == restoredInput // true
