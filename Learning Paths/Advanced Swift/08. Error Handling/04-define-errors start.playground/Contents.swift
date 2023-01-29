// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.



do {
  throw BasicError.bam
}
catch {
  print("Default match", error)
}

enum BasicError: Int, Error {
  case boom = 100
  case bam
}

enum FancyError: Error {
  case something(String)
}

do {
  throw FancyError.something("I'm an error")
}
catch (let error as BasicError) {
  print("Basic error", error)
}
catch FancyError.something(let message) {
  print ("Fancy error", message)
}
catch {
  print ("All other errors", error)
}
