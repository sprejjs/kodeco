// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

enum PlainError: Int, Error {
  case boom = 100
  case bam = 101
}

do {
  throw PlainError.bam
}
catch (let error as NSError) {
  dump(error)
}

enum FancyError: Error {
  case kazam(String)
}

do {
  throw FancyError.kazam("Help")
}
catch (let error as NSError) {
  dump(error)
}

do {
  let file = try FileHandle(forReadingFrom: URL(fileURLWithPath: "sdf"))
  print(file)
}
catch (let error as NSError) {
  dump(error)
}
