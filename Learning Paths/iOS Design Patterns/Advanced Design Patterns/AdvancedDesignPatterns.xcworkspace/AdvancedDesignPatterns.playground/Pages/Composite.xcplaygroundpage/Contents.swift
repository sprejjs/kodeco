/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Composite
 - - - - - - - - - -
 ![Composite Diagram](Composite_Diagram.png)
 
 The composite pattern is a structural pattern that groups a set of objects into a tree so that they may be manipulated as though they were one object. It uses three types:
 
 1. The **component protocol** ensures all constructs in the tree can be treated the same way.
 2. A **leaf** is a component of the tree that does not have child elements.
 3. A **composite** is a container that can hold leaf objects and composites.
 
 ## Code Example
 */

 import Foundation

 public protocol File {
  var name: String { get }
  func open()
 }

 struct eBook: File {
  var name: String
  var author: String

  func open() {
    print("Opening \(name) book by \(author).")
  }
 }

 struct Music: File {
  var name: String
  var artist: String

  func open() {
    print("Opening \(name) song by \(artist).")
  }
 }

 struct Folder: File {
  var name: String
  var files: [File]

  mutating func addFile(_ file: File) {
    files.append(file)
  }

  func open() {
    print("Displaying files in \(name) folder:")
    files.forEach { print("- \($0.name)") }
  }
 }

 // Mark: - Usage
 let psychoKiller = Music(name: "Psycho Killer", artist: "Talking Heads")
 let killingStrangers = Music(name: "Killing Strangers", artist: "Marylin Manson")
 let theHungerGames = eBook(name: "The Hunger Games", author: "Suzanne Collins")

 var documents = Folder(name: "Documents", files: [theHungerGames])
 let music = Folder(name: "Music", files: [psychoKiller, killingStrangers])
 documents.addFile(music)

 documents.open()
