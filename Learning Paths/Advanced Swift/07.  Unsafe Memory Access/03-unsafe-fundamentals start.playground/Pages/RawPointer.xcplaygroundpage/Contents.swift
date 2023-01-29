// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

// Allocate space for 2 Int
let stride = MemoryLayout<Int>.stride
let alignment = MemoryLayout<Int>.alignment
let count = 2

let byteCount = stride * count
let pointer = UnsafeMutableRawPointer
  .allocate(
    byteCount: byteCount,
    alignment: alignment)

defer {
  pointer.deallocate()
}

pointer.storeBytes(of: 4095, as: Int.self) // Stores the value 4095 in the first word of the pointer
(pointer + stride).storeBytes(of: 6, as: Int.self)
pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self) // Stores the value 6 in the second word of the pointer

var value: Int = pointer.load(as: Int.self) // Reads the value from the first word.
var value2: Int = pointer.advanced(by: stride).load(as: Int.self) // Reads the value from the second word

let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount)

for (offset, byte) in bufferPointer.enumerated() {
  print("byte: \(offset): \(byte)")
}
