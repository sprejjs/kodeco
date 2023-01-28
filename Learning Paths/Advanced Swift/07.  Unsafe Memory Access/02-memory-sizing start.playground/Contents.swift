// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

MemoryLayout<Int>.size          // returns 8 (on 64-bit)
MemoryLayout<Int>.alignment     // returns 8 (on 64-bit)
MemoryLayout<Int>.stride        // returns 8 (on 64-bit)

MemoryLayout<Int16>.size        // returns 2
MemoryLayout<Int16>.alignment   // returns 2
MemoryLayout<Int16>.stride      // returns 2

MemoryLayout<Bool>.size         // returns 1
MemoryLayout<Bool>.alignment    // returns 1
MemoryLayout<Bool>.stride       // returns 1

MemoryLayout<Float>.size        // returns 4
MemoryLayout<Float>.alignment   // returns 4
MemoryLayout<Float>.stride      // returns 4

MemoryLayout<Double>.size       // returns 8
MemoryLayout<Double>.alignment  // returns 8
MemoryLayout<Double>.stride     // returns 8


MemoryLayout<SomeStruct>.alignment // 8
MemoryLayout<SomeStruct>.size // 17
MemoryLayout<SomeStruct>.stride // 24

struct SomeStruct {
  let a: Bool = false
  var number: Int = 12 {
    didSet {} // <- Property observer
  }
  let b: Bool = true
}

MemoryLayout.offset(of: \SomeStruct.number) // nil

func pad(string : String, toSize: Int) -> String {
  var padded = string
  for _ in 0..<(toSize - string.count) {
    padded = "0" + padded
  }
    return padded
}

let num = 10
let str = String(num, radix: 2)
print(str) // 10110
print(pad(string: str, toSize: 64))  // 00010110
