/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

enum IntegerOperation<IntType: FixedWidthInteger> {
  typealias Operation = (IntType) -> IntType

  struct Section {
    let title: String
    let items: [Item]
  }

  struct Item {
    let name: String
    let operation: Operation
  }
}

private extension UInt8 {
  mutating func reverseBits() {
    self = (0b11110000 & self) >> 4 | (0b00001111 & self) << 4
    self = (0b11001100 & self) >> 2 | (0b00110011 & self) << 2
    self = (0b10101010 & self) >> 1 | (0b01010101 & self) << 1
  }
}

extension FixedWidthInteger {
  var bitReversed: Self {
    var reversed = byteSwapped
    withUnsafeMutableBytes(of: &reversed) { buffer in
      buffer.indices.forEach { buffer[$0].reverseBits() }
    }
    return reversed
  }
}


extension IntegerOperation {
  static var menu: [Section] {
    [
      Section(title: "Set value", items: [
        Item(name: "value = 0") { _ in 0 },
        Item(name: "value = 1") { _ in 1 },
        Item(name: "all ones") { _ in ~IntType.zero },
        Item(name: "value = -1") { _ in -1 },
        Item(name: "max") { _ in IntType.max },
        Item(name: "min") { _ in IntType.min },
        Item(name: "random") { _ in
          IntType.random(in: IntType.min...IntType.max)
        }
      ]),
      Section(title: "Endian", items: [
        Item(name: "bigEndian") { $0.bigEndian },
        Item(name: "littleEndian") { $0.littleEndian },
        Item(name: "byteSwapped") { $0.byteSwapped }
      ]),
      Section(title: "Bit Manipulation", items: [
        Item(name: "toggle") { ~$0 },
        Item(name: "value << 1") { value in value << 1 },
        Item(name: "value >> 1") { value in value >> 1 },
        Item(name: "reverse") { $0.bitReversed }
      ]),
      Section(title: "Arithmetic", items: [
         Item(name: "value + 1") { value in value &+ 1 },
         Item(name: "value - 1") { value in value &- 1 },
         Item(name: "value * 10") { value in value &* 10 },
         Item(name: "value / 10") { value in value / 10 },
         Item(name: "negate") { value in ~value &+ 1 }
      ])
    ]
  }
}

struct IntegerOperationsView<IntType: FixedWidthInteger>: View {
  @Binding var value: IntType

  var body: some View {
    List {
      ForEach(IntegerOperation<IntType>.menu, id: \.title) { section in
        Section(header: Text(section.title)) {
          ForEach(section.items, id: \.name) { item in
            HStack {
              Image(systemName: "function")
              Button(item.name) {
                value = item.operation(value)
              }
            }
          }
        }
      }
    }.listStyle(GroupedListStyle())
    .navigationTitle("\(String(describing: IntType.self)) Operations")
  }
}

struct FloatingPointOperationsView<FloatType: BinaryFloatingPoint & DoubleConvertable>: View {
  @Binding var value: FloatType

  var body: some View {
    List {
// TODO: - Uncomment after implementing FloatingPointOperation
//      ForEach(FloatingPointOperation<FloatType>.menu, id: \.title) { section in
//        Section(header: Text(section.title)) {
//          ForEach(section.items, id: \.name) { item in
//            HStack {
//              Image(systemName: "function")
//              Button(item.name) {
//                value = item.operation(value)
//              }
//            }
//          }
//        }
//      }
    }.listStyle(GroupedListStyle())
    .navigationViewStyle(StackNavigationViewStyle())
    .navigationTitle("\(String(describing: FloatType.self)) Operations")
  }
}
