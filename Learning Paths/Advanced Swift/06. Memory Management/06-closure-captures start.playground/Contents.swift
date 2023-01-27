// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.


var value = 0

let show = { // <- As we haven't used the capture list, the initial variable is captured.
  print(value)
}

show()
value = 10
show()

let show2 = { [value] in // <- Here we've used a capture list. At this point the closure has created an immutable copy of the variable.
  print(value)
}

show2()
value = 4
show()
show2()

let show3 = { [v = value, b = value + 1] in // <- Here we've created two immutable variables and assigned them a value based on the outside variable called value
  print(v, b)
}

show3()

class Cat {
  func speak() { print("meow") }
}

var play: ()->Void

do {
  let whiskers = Cat()

  play = { [weak cat = whiskers] in
    guard let cat else {
      print("No playing time")
      return
    }
    cat.speak()
  }

  play()
}

play()

