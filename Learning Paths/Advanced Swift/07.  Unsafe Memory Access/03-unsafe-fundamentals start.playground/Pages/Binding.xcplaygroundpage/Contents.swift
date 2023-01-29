// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

let count = 3
let stride = MemoryLayout<Int16>.stride
let alignment = MemoryLayout<Int16>.alignment
let byteCount =  count * stride

let pointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
defer {
  pointer.deallocate()
}

let typedPointer1 = pointer.bindMemory(to: UInt16.self, capacity: count)
let typedPointer2 = pointer.bindMemory(to: Bool.self, capacity: count * 2)

typedPointer1.withMemoryRebound(to: Bool.self, capacity: count * 2) { boolPointer in
  print(boolPointer.pointee)
}
