/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Model-View-ViewModel (MVVM)
 - - - - - - - - - -
 ![MVVM Diagram](MVVM_Diagram.png)
 
 The Model-View-ViewModel (MVVM) pattern separates objects into three types: models, views and view-models.
 
 - **Models** hold onto application data. They are usually structs or simple classes.
 - **View-models** convert models into a format that views can use.
 - **Views** display visual elements and controls on screen. They are usually subclasses of `UIView`.
 
 ## Code Example
 */
import UIKit
import PlaygroundSupport

@available(iOS 2, *)
public final class Pet {
  public enum Rarity {
    case common
    case rare
    case legendary
  }

  public let name: String
  public let rarity: Rarity
  public let birthday: Date
  public let image: UIImage

  public init(name: String, rarity: Rarity, birthday: Date, image: UIImage) {
    self.name = name
    self.rarity = rarity
    self.birthday = birthday
    self.image = image
  }
}

// MARK: - ViewModel
@available(iOS 2, *)
public final class PetViewModel {
  public let pet: Pet
  public let calendar: Calendar

  public init(pet: Pet, calendar: Calendar = .current) {
    self.pet = pet
    self.calendar = calendar
  }

  public var name: String {
    return pet.name
  }

  public var image: UIImage {
    return pet.image
  }

  public var ageText: String {
    let today = calendar.startOfDay(for: Date())
    let birthday = calendar.startOfDay(for: pet.birthday)
    let components = calendar.dateComponents([.year], from: birthday, to: today)
    let age = components.year!
    return "\(age) years old"
  }

  public var adoptionFee: String {
    switch pet.rarity {
      case .common:
        return "$50"
      case .rare:
        return "$100"
      case .legendary:
        return "$500"
    }
  }
}

extension PetViewModel {
  public func configure(_ view: PetView) {
    view.nameLabel.text = name
    view.ageLabel.text = ageText
    view.adoptionFeeLabel.text = adoptionFee
    view.imageView.image = image
  }
}

// MARK: - View
@available(iOS 2, *)
public final class PetView: UIView {
  public let imageView: UIImageView
  public let nameLabel: UILabel
  public let ageLabel: UILabel
  public let adoptionFeeLabel: UILabel

  public override init(frame: CGRect) {
    var childFrame = CGRect(x: 0.0, y: 16.0, width: frame.width, height: frame.height / 2.0)
    imageView = UIImageView(frame: childFrame)
    imageView.contentMode = .scaleAspectFit

    childFrame.origin.y += childFrame.height + 16.0
    childFrame.size.height = 30.0
    nameLabel = UILabel(frame: childFrame)
    nameLabel.textAlignment = .center

    childFrame.origin.y += childFrame.height + 8.0
    ageLabel = UILabel(frame: childFrame)
    ageLabel.textAlignment = .center

    childFrame.origin.y += childFrame.height + 8.0
    adoptionFeeLabel = UILabel(frame: childFrame)
    adoptionFeeLabel.textAlignment = .center

    super.init(frame: frame)
    backgroundColor = .white
    [imageView, nameLabel, ageLabel, adoptionFeeLabel].forEach(addSubview)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Example

let birthday = Date(timeIntervalSince1970: 1_400_000_000)
let image = UIImage(named: "stuart")!
let stuart = Pet(name: "Stuart", rarity: .legendary, birthday: birthday, image: image)
let viewModel = PetViewModel(pet: stuart)

let frame = CGRect(x: 0.0, y: 0.0, width: 300, height: 420)
let view = PetView(frame: frame)
viewModel.configure(view)

PlaygroundPage.current.liveView = view
