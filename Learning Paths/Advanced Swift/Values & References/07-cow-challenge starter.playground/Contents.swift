// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

// The other use case for implementing COW is to reduce reference counting
// traffic.  The following Inventorystorage struct has value semantics
// because the all of the internal components have value semantics.
// However, everytime an object is copied you get 6 reference counts
// Use COW so that there is only one reference count bump when an
// Inventorystorage is copied.

import class UIKit.UIColor
import class UIKit.UIImage

struct InventoryItem {
  private var storage: Storage

  private final class Storage {
    var name: String
    var cost: String
    var barcode: String
    var color: UIColor
    var images: [UIImage]
    var comment: String

    init(name: String, cost: String, barcode: String, color: UIColor, images: [UIImage], comment: String) {
      self.name = name
      self.cost = cost
      self.barcode = barcode
      self.color = color
      self.images = images
      self.comment = comment
    }
  }

  init(name: String, cost: String, barcode: String, color: UIColor, images: [UIImage], comment: String) {
    self.storage = Storage(name: name, cost: cost, barcode: barcode, color: color, images: images, comment: comment)
  }

  var name: String {
    get { storage.name }
    set {
      if !isKnownUniquelyReferenced(&storage) {
        storage = Storage(name: newValue, cost: storage.cost, barcode: storage.barcode, color: storage.color, images: storage.images, comment: storage.comment)
        return
      }
      storage.name = newValue
    }
  }

  var cost: String {
    get { storage.cost }
    set {
      if !isKnownUniquelyReferenced(&storage) {
        storage = Storage(name: storage.name, cost: newValue, barcode: storage.barcode, color: storage.color, images: storage.images, comment: storage.comment)
        return
      }
      storage.cost = newValue
    }
  }

  var barcode: String {
    get { storage.barcode }
    set {
      if !isKnownUniquelyReferenced(&storage) {
        storage = Storage(name: storage.name, cost: storage.cost, barcode: newValue, color: storage.color, images: storage.images, comment: storage.comment)
        return
      }
      storage.barcode = newValue
    }
  }

  var color: UIColor {
    get { storage.color }
    set {
      if !isKnownUniquelyReferenced(&storage) {
        storage = Storage(name: storage.name, cost: storage.cost, barcode: storage.barcode, color: newValue, images: storage.images, comment: storage.comment)
        return
      }
      storage.color = newValue
    }
  }

  var images: [UIImage] {
    get { storage.images }
    set {
      if !isKnownUniquelyReferenced(&storage) {
        storage = Storage(name: storage.name, cost: storage.cost, barcode: storage.barcode, color: storage.color, images: newValue, comment: storage.comment)
        return
      }
      storage.images = newValue
    }
  }

  var comment: String {
    get { storage.comment }
    set {
      if !isKnownUniquelyReferenced(&storage) {
        storage = Storage(name: storage.name, cost: storage.cost, barcode: storage.barcode, color: storage.color, images: storage.images, comment: newValue)
        return
      }
      storage.comment = newValue
    }
  }
}

var inventoryItem = InventoryItem(name: "Test", cost: "$23", barcode: "1234", color: .red, images: [], comment: "There is an inventory storage")
var inventoryItem2 = inventoryItem

inventoryItem2.name = "New Name" // COW is executed here
print(inventoryItem.name)
print(inventoryItem2.name)
