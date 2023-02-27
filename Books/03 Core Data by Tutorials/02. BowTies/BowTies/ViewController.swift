/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreData

class ViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var timesWornLabel: UILabel!
  @IBOutlet weak var lastWornLabel: UILabel!
  @IBOutlet weak var favoriteLabel: UILabel!
  @IBOutlet weak var wearButton: UIButton!
  @IBOutlet weak var rateButton: UIButton!

  private var currentBowTie: BowTie! {
    didSet {
      populate(bowTie: currentBowTie)
    }
  }

  private lazy var appDelegate: AppDelegate = {
    (UIApplication.shared.delegate as! AppDelegate)
  }()

  private lazy var managedContext: NSManagedObjectContext = {
    appDelegate.persistentContainer.viewContext
  }()

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    insertSampleData()

    let request = BowTie.fetchRequest()
    let firstTitle = segmentedControl.titleForSegment(at: 0) ?? ""
    request.predicate = NSPredicate(
      format: "\(#keyPath(BowTie.searchKey)) == '\(firstTitle)'")

    let results = try! managedContext.fetch(request)
    if let tie = results.first {
      currentBowTie = tie
    }
  }

  // MARK: - IBActions

  @IBAction func segmentedControl(_ sender: UISegmentedControl) {
    guard let selectedValue = sender.titleForSegment(at: sender.selectedSegmentIndex) else {
      return
    }

    let request = BowTie.fetchRequest()
    request.predicate = NSPredicate(format: "\(#keyPath(BowTie.searchKey)) == '\(selectedValue)'")

    let results = try! managedContext.fetch(request)
    currentBowTie = results.first
  }

  @IBAction func wear(_ sender: UIButton) {
    currentBowTie.timesWorn += 1
    currentBowTie.lastWorn = Date()

    appDelegate.saveContext()
    populate(bowTie: currentBowTie)
  }

  @IBAction func rate(_ sender: UIButton) {
    let alert = UIAlertController(
      title: "New Rating",
      message: "Rate this bow tie",
      preferredStyle: .alert)

    alert.addTextField { textField in
      textField.keyboardType = .decimalPad
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    let saveAction = UIAlertAction(
      title: "Save", style: .default) { [unowned self] _ in
        if let textField = alert.textFields?.first {
          self.update(rating: textField.text)
        }
      }

    alert.addAction(cancelAction)
    alert.addAction(saveAction)

    present(alert, animated: true)
  }

  private func update(rating: String?) {
    guard
      let rating,
      let rating = Double(rating)
    else {
      return
    }

    currentBowTie.rating = rating
    populate(bowTie: currentBowTie)
    appDelegate.saveContext()
  }

  private func insertSampleData() {
    let fetch: NSFetchRequest<BowTie> = BowTie.fetchRequest()
    fetch.predicate = NSPredicate(format: "searchKey != nil")

    let tieCount = (try? managedContext.count(for: fetch)) ?? 0

    guard tieCount == 0 else {
      // Already done
      return
    }

    let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
    let dataArray = NSArray(contentsOfFile: path!)!

    for dict in dataArray {
      let bowTie = BowTie(context: managedContext)
      let dict = dict as! [String: Any]

      bowTie.id = UUID(uuidString: dict["id"] as! String)
      bowTie.name = dict["name"] as? String
      bowTie.searchKey = dict["searchKey"] as? String
      bowTie.rating = dict["rating"] as! Double
      let colorDict = dict["tintColor"] as! [String: Any]
      bowTie.tintColor = UIColor.color(dict: colorDict)

      let imageName = dict["imageName"] as! String
      let image = UIImage(named: imageName)
      bowTie.photoData = image?.pngData()
      bowTie.lastWorn = dict["lastWorn"] as? Date

      let timesWorn = dict["timesWorn"] as! NSNumber
      bowTie.timesWorn = timesWorn.int32Value
      bowTie.isFavorite = dict["isFavorite"] as! Bool
      bowTie.url = URL(string: dict["url"] as! String)
    }

    try? managedContext.save()
  }

  private func populate(bowTie: BowTie) {
    guard let imageData = bowTie.photoData as Data?,
          let lastWorn = bowTie.lastWorn as Date?,
          let tintColor = bowTie.tintColor else {
      return
    }

    imageView.image = UIImage(data: imageData)
    nameLabel.text = bowTie.name
    ratingLabel.text = "Rating: \(bowTie.rating)/5"
    timesWornLabel.text = "# times worn: \(bowTie.timesWorn)"

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none

    lastWornLabel.text = "Last worn: \(dateFormatter.string(from: lastWorn))"

    favoriteLabel.isHidden = !bowTie.isFavorite
    view.tintColor = tintColor
  }
}

private extension UIColor {
  static func color(dict: [String: Any]) -> UIColor {
    let red = dict["red"] as! NSNumber
    let green = dict["green"] as! NSNumber
    let blue = dict["blue"] as! NSNumber

    return UIColor(
      red: CGFloat(truncating: red) / 255.0,
      green: CGFloat(truncating: green) / 255.0,
      blue: CGFloat(truncating: blue) / 255.0,
      alpha: 1)
  }
}
