// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

struct Tracked<Value>: CustomDebugStringConvertible {
  private var _value: Value
  private(set) var readCount = 0
  private(set) var writeCount = 0

  init(_ value: Value) {
    self._value = value
  }

  mutating func resetCounts() {
    readCount = 0
    writeCount = 0
  }

  var debugDescription: String {
    return "\(_value) Reads: \(readCount) Writes: \(writeCount)"
  }

  var value: Value {
    mutating get {
      readCount += 1
      return _value
    }
    set { // set is implicitly mutating.
      writeCount += 1
      _value = newValue
    }
  }
}

func computeNothing(input: inout Int) {}

func compute100Times(input: inout Int) {
  for _ in 1...100 {
    input += 1
  }
}

var tracked = Tracked(40)
computeNothing(input: &tracked.value)
print(tracked)
tracked.resetCounts()
compute100Times(input: &tracked.value)
print(tracked)
