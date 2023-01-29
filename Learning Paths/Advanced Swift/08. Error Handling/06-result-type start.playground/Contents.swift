// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.


enum Result<Success, Failure: Error> {
  case success(Success)
  case failure(Failure)

  func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> Result<NewSuccess, Failure> {
    switch self {
    case .success(let success):
      return .success(transform(success))
    case .failure(let error):
      return .failure(error)
    }
  }

  func flatMap<NewSuccess>(_ transform: (Success) -> Result<NewSuccess, Failure>) -> Result<NewSuccess, Failure> {
    switch self {
    case .success(let value):
      return transform(value)
    case .failure(let error):
      return .failure(error)
    }
  }

  func get() throws -> Success {
    switch self {
    case .success(let value):
      return value
    case .failure(let error):
      throw error
    }
  }
}

enum MathError: Error {
  case divisionByZero
}

func divide(_ a: Double, _ b: Double) throws -> Double {
  guard b != 0 else {
    throw MathError.divisionByZero
  }
  return a/b
}

func divide2(_ a: Double, _ b: Double) -> Result<Double, MathError> {
  guard b != 0 else {
    return .failure(.divisionByZero)
  }
  return .success(a/b)
}

try? divide(10, 0)
divide2(10, 2)

let result: Result<Result<Double, MathError>, MathError> = divide2(10, 5).map { divide2($0, 5)}
let result2: Result<Double, MathError> = divide2(10, 5).flatMap { divide2($0, 5)}
let value = try? result2.get()
