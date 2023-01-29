// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

let count = 2
let stride = MemoryLayout<Int>.stride
let alignment = MemoryLayout<Int>.alignment
let byteCount = stride * count

// Converting raw pointers to typed pointers

let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
defer {
  rawPointer.deallocate()
}
rawPointer.storeBytes(of: 4095, as: Int.self)

let typedPointer = rawPointer.bindMemory(to: Int.self, capacity: count)

var value = typedPointer.pointee
print(value)
// The second word in the pointer was never initialised. There is no way of telling what would be printed when we try to read the memory.
print((typedPointer + stride).pointee)
