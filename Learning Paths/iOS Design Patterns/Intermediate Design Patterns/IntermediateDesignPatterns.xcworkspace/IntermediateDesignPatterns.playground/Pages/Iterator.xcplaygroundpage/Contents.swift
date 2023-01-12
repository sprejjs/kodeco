/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Iterator
 - - - - - - - - - -
 ![Iterator Diagram](Iterator_Diagram.png)
 
 The Iterator Pattern provides a standard way to loop through a collection. This pattern involves two types:
 
 1. The Swift `Iterable` protocol defines a type that can be iterated using a `for in` loop.
 
 2. A **custom object** you want to make iterable. Instead of conforming to `Iterable` directly, however, you can conform to `Sequence`, which itself conforms to `Iterable`. By doing so, you'll get many higher-order functions, including `map`, `filter` and more, implemented for free for you.
 
 ## Code Example
 */

import Foundation

public struct Queue<T> {
  private var array: [T?] = []
  private var head = 0

  public var isEmpty: Bool {
    return count == 0
  }

  public var count: Int {
    return array.count - head
  }

  public mutating func enqueue(_ element: T) {
    array.append(element)
  }

  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    let percentage = Double(head)/Double(array.count)
    if array.count > 50 && percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }

    return element
  }
}

public struct Ticket {
  enum PriorityType {
    case low
    case medium
    case high
  }
  var description: String
  var priority: PriorityType
}

var queue = Queue<Ticket>()
queue.enqueue(Ticket(description: "Need help with iOS", priority: .high))
queue.enqueue(Ticket(description: "Need help with Android", priority: .medium))
queue.enqueue(Ticket(description: "Need help with Web", priority: .low))
queue.enqueue(Ticket(description: "Need help with ML", priority: .high))

extension Queue: Sequence {
  public func makeIterator() -> IndexingIterator<Array<T>> {
    let nonEmptyValues = Array(array[head..<array.count]) as! [T]
    return nonEmptyValues.makeIterator()
  }
}

print("List of tickets:")
for ticket in queue {
  print("Priority \(ticket.priority): \(ticket.description)")
}

extension Ticket {
  var sortIndex: Int {
    switch priority {
    case .low:
      return 0
    case .medium:
      return 1
    case .high:
      return 2
    }
  }
}

print("\nList of tickets sorted by priority:")
let sortedTickets = queue.sorted { $0.sortIndex < $1.sortIndex }

for ticket in sortedTickets {
  print("Priority \(ticket.priority): \(ticket.description)")
}
