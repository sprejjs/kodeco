// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

let count = 2

let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)

pointer.initialize(repeating: 0, count: count)

defer {
  pointer.deinitialize(count: count)
  pointer.deallocate()
}

// Storing values
pointer.pointee = 125
pointer.advanced(by: 1).pointee = 250
(pointer + 1).pointee = 251

// Reading values
var value = pointer.pointee
var value1 = pointer.advanced(by: 1).pointee
var value2 = (pointer + 1).pointee

// Looping over the values
let bufferPointer = UnsafeBufferPointer(start: pointer, count: count)

for (offset, value) in bufferPointer.enumerated() {
  print("value \(offset): \(value)")
}
