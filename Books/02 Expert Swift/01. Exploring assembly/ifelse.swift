@inlinable public func ifelse<T>(
  _ condition: Bool,
  _ valueTrue: @autoclosure () throws -> T,
  _ valueFalse: @autoclosure () throws -> T
) rethrows -> T {
  condition ? try valueTrue() : try valueFalse()
}

func ifelseTest1() -> Int {
  if .random() {
    return 100
  } else {
    return 200
  }
}

func ifelseTest2() -> Int {
  Bool.random() ? 300 : 400
}

func ifelseTest3() -> Double {
  ifelse(.random(), 500.0, 600.0)
}
