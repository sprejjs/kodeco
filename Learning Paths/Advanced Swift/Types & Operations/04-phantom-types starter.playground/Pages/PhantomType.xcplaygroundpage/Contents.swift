// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

struct Named<T>: Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
  var name: String
  init(_ name: String) {
    self.name = name
  }

  init(stringLiteral value: String) {
    self.name = value
  }

  var description: String {
    name
  }
}

enum StateTag {}
enum CapitalTag {}

typealias State = Named<StateTag>
typealias Capital = Named<StateTag>

var lookup: [State: Capital] = ["Alabama": "Montgomery",
                                "Alaska":  "Juneau",
                                "Arizona": "Phoenix"]

func printStateAndCapital(_ state: State, _ capital: Capital) {
  print("The capital of \(state) is \(capital)")
}

func test() {
  let alaska = State("Alaska")
  guard let capital = lookup[alaska] else {
    return
  }
  printStateAndCapital(alaska, capital)
}

test()
