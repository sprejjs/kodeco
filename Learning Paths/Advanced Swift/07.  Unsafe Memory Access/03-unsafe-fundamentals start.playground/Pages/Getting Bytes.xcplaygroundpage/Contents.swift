// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

struct SampleStruct {
  let number: UInt32
  let flag: Bool
}

var sampleStruct = SampleStruct(number: 25, flag: true)

withUnsafeBytes(of: &sampleStruct) { bytes in
  for (count, byte) in bytes.enumerated() {
    print("\(count): -> \(byte)")
  }
}

// 25 < - First byte of the number
// 0 <- Still number
// 0 <- Still number
// 0 <- Still number
// 1 <- Boolean


struct SomeStruct {
  let a: Bool = false
  let number: Int = 12
  let b: Bool = true
}

var someStruct = SomeStruct()
print("Some struct")

withUnsafeBytes(of: &someStruct) { bytes in
  for (count, byte) in bytes.enumerated() {
    print("\(count): -> \(byte)")
  }
}

// 0: 0 <- Boolean
// 1: 0 <- Padding
// 2: 0 <- Padding
// 3: 0 <- Padding
// 4: 0 <- Padding
// 5: 0 <- Padding
// 6: 0 <- Padding
// 7: 0 <- Padding
// 8: 12 <- Number
// 9: 0 <- Number
// 10: 0 <- Number
// 11: 0 <- Number
// 12: 0 <- Number
// 13: 0 <- Number
// 14: 0 <- Number
// 15: 0 <- Number
// 16: 1 <- Boolean

let checkshum = withUnsafeBytes(of: &sampleStruct) { bytes -> UInt32 in
  return ~bytes.reduce(0) { $0 + numericCast($1) }
}
print(checkshum)
