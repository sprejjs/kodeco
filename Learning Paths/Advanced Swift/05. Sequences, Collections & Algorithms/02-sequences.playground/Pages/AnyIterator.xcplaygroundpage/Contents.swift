// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import Foundation

func infinite(value: Int) -> AnySequence<Int> {
  return AnySequence<Int> { AnyIterator<Int> { value } }
}
