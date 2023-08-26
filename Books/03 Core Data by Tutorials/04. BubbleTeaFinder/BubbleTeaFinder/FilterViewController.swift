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

protocol FilterViewControllerDelegate: AnyObject {
  func filterViewController(
    filter: FilterViewController,
    didSelectPredicate predicate: NSPredicate?,
    sortDescriptor: NSSortDescriptor?)
}

class FilterViewController: UITableViewController {
  @IBOutlet weak var firstPriceCategoryLabel: UILabel!
  @IBOutlet weak var secondPriceCategoryLabel: UILabel!
  @IBOutlet weak var thirdPriceCategoryLabel: UILabel!
  @IBOutlet weak var numDealsLabel: UILabel!

  // MARK: - Price section
  @IBOutlet weak var cheapVenueCell: UITableViewCell!
  @IBOutlet weak var moderateVenueCell: UITableViewCell!
  @IBOutlet weak var expensiveVenueCell: UITableViewCell!

  // MARK: - Most popular section
  @IBOutlet weak var offeringDealCell: UITableViewCell!
  @IBOutlet weak var walkingDistanceCell: UITableViewCell!
  @IBOutlet weak var userTipsCell: UITableViewCell!

  // MARK: - Sort section
  @IBOutlet weak var nameAZSortCell: UITableViewCell!
  @IBOutlet weak var nameZASortCell: UITableViewCell!
  @IBOutlet weak var distanceSortCell: UITableViewCell!
  @IBOutlet weak var priceSortCell: UITableViewCell!

  var coreDataStack: CoreDataStack!
  weak var delegate: FilterViewControllerDelegate?
  var selectedSortDescriptor: NSSortDescriptor?
  var selectedPredicate: NSPredicate?

  private lazy var cheapVenuePredicate: NSPredicate = {
    NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$")
  }()

  private lazy var moderateVenuePredicate: NSPredicate = {
    NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$$")
  }()

  private lazy var expensiveVenuePredicate: NSPredicate = {
    NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$$$")
  }()

  private lazy var offeringDealPredicate: NSPredicate = {
    NSPredicate(
      format: "%K > 0",
      #keyPath(Venue.specialCount))
  }()

  private lazy var walkingDistancePredicate: NSPredicate = {
    NSPredicate(
      format: "%K < 500",
      #keyPath(Venue.location.distance))
  }()

  private lazy var hasUserTipsPredicate: NSPredicate = {
    NSPredicate(
      format: "%K > 0",
      #keyPath(Venue.stats.tipCount))
  }()

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    populateCheapVenueCountLabel()
    populateModerateVenueCountLabel()
    populateExpensiveVenueCountLabel()
    populateDealsCountLabel()
  }
}

// MARK: - IBActions
extension FilterViewController {
  @IBAction func search(_ sender: UIBarButtonItem) {
    delegate?.filterViewController(
      filter: self,
      didSelectPredicate: selectedPredicate,
      sortDescriptor: selectedSortDescriptor)

    dismiss(animated: true)
  }
}

// MARK: - UITableViewDelegate
extension FilterViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }

    switch cell {
    case cheapVenueCell:
      selectedPredicate = cheapVenuePredicate
    case moderateVenueCell:
      selectedPredicate = moderateVenuePredicate
    case expensiveVenueCell:
      selectedPredicate = expensiveVenuePredicate
    case offeringDealCell:
      selectedPredicate = offeringDealPredicate
    case walkingDistanceCell:
      selectedPredicate = walkingDistancePredicate
    case userTipsCell:
      selectedPredicate = hasUserTipsPredicate
    default:
      break
    }

    cell.accessoryType = .checkmark
  }
}

extension FilterViewController {
  func populateCheapVenueCountLabel() {
    let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
    fetchRequest.resultType = .countResultType
    fetchRequest.predicate = cheapVenuePredicate

    fetchRequest.fetchBatchSize = 10 // <- Fetch information in batches of 10 objects.
    fetchRequest.fetchLimit = 5 // <- Limit the result to 5 objects.
    fetchRequest.fetchOffset = 5 // <- Skip the first 5 objects.

    do {
      let countResult = try coreDataStack.managedContext.fetch(fetchRequest)

      let count = countResult.first?.intValue ?? 0
      let pluralized = count == 1 ? "place" : "places"
      firstPriceCategoryLabel.text = "\(count) bubble tea \(pluralized)"
    } catch let error as NSError {
      print("Count not fetched \(error), \(error.userInfo)")
    }
  }

  func populateModerateVenueCountLabel() {
    let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
    fetchRequest.resultType = .countResultType
    fetchRequest.predicate = moderateVenuePredicate

    do {
      let countResult = try coreDataStack.managedContext.fetch(fetchRequest)

      let count = countResult.first?.intValue ?? 0
      let pluralized = count == 1 ? "place" : "places"
      secondPriceCategoryLabel.text = "\(count) bubble tea \(pluralized)"
    } catch let error as NSError {
      print("Count not fetched \(error), \(error.userInfo)")
    }
  }

  func populateExpensiveVenueCountLabel() {
    let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
    fetchRequest.predicate = expensiveVenuePredicate

    do {
      let count = try coreDataStack.managedContext.count(for: fetchRequest)
      let pluralized = count == 1 ? "place" : "places"
      thirdPriceCategoryLabel.text = "\(count) bubble tea \(pluralized)"
    } catch let error as NSError {
      print("Count not fetched \(error), \(error.userInfo)")
    }
  }

  func populateDealsCountLabel() {
    let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Venue")
    fetchRequest.resultType = .dictionaryResultType

    let sumExpressionDesc = NSExpressionDescription()
    sumExpressionDesc.name = "sumDeals"

    let specialCountExp = NSExpression(forKeyPath: #keyPath(Venue.specialCount))
    sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [specialCountExp])
    sumExpressionDesc.expressionResultType = .integer32AttributeType

    fetchRequest.propertiesToFetch = [sumExpressionDesc]

    do {
      let results = try coreDataStack.managedContext.fetch(fetchRequest)

      let resultDict = results.first
      let numDeals = resultDict?["sumDeals"] as? Int ?? 0
      let pluralized = numDeals == 1 ? "deal" : "deals"
      numDealsLabel.text = "\(numDeals) \(pluralized)"

    } catch let error as NSError {
      print("count not fetched \(error), \(error.userInfo)")
    }
  }
}
