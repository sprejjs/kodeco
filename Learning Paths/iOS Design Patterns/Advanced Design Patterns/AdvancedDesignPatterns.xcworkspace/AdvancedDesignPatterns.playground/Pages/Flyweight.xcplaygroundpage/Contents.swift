/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Flyweight
 - - - - - - - - - -
 ![Flyweight Diagram](Flyweight_Diagram.png)
 
 The Flyweight Pattern is a structural design pattern that minimizes memory usage and processing.
 
 The flyweight pattern provides a shared instance that allows other instances to be created too. Every reference to the class refers to the same underlying instance.
 
 ## Code Example
 */

import UIKit

let red = UIColor.red
let red2 = UIColor.red

print(red === red2) // true, demonstrating that UIColor is flyweight

let color2 = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
let color3 = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
print(color2 === color3) // false

extension UIColor {
  public static var colorStore: [String: UIColor] = [:]

  public class func rgba(
    red: CGFloat,
    green: CGFloat,
    blue: CGFloat,
    alpha: CGFloat
  ) -> UIColor {
    let key = "\(red)\(green)\(blue)\(alpha)"
    if let color = colorStore[key] {
      return color
    } else {
      let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
      colorStore[key] = color
      return color
    }
  }
}

let flyColor = UIColor.rgba(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
let flyColor2 = UIColor.rgba(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)

print(flyColor === flyColor2) // true
