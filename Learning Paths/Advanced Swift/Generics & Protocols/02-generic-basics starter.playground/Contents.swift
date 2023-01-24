// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

struct Stack<T> {
  
  private var storage: [T] = []
  
  mutating func push(_ element: T) {
    storage.append(element)
  }
  
  mutating func pop() -> T? {
    return storage.popLast()
  }
  
  var top: T? {
    return storage.last
  }
  
  var isEmpty: Bool {
    return top == nil
  }
  
}

var stack = Stack<Int>()
stack.push(20)
stack.push(21)
stack.pop()

extension Stack: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: T...) {
    self.storage = elements
  }
}

var anotherStack: Stack = [1, 2, 3, 4]
anotherStack.pop()
