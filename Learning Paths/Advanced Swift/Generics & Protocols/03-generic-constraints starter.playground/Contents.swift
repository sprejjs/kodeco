// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

func add<T: Numeric>(_ a: T, _ b: T) -> T {
  a + b
}

add(3, 4)
add(UInt8(20), UInt8(33))

// Without constraining the T parameter, the compiler doesn't know if we can add two T types together
add(3, 4)
add(UInt8(20), UInt8(33))
