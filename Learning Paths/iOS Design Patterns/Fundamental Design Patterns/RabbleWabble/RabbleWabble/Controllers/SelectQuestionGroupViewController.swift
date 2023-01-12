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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

public class SelectQuestionGroupViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet internal var tableView: UITableView! {
    didSet {
      tableView.tableFooterView = UIView()
    }
  }
  
  // MARK: - Properties
  private let questionGroupCaretaker = QuestionGroupCaretaker()
  private var selectedQuestionGroup: QuestionGroup {
    get { questionGroupCaretaker.selectedQuestionGroup }
    set { questionGroupCaretaker.selectedQuestionGroup = newValue }
  }
  
  // MARK: - View Lifecycle  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    deselectTableViewCells()

    printScoreToConsole()
  }

  func printScoreToConsole() {
    questionGroupCaretaker.questionGroups.forEach {
      print("\($0.title): correctCount = \($0.score.correctCount), incorrectCount = \($0.score.incorrectCount)")
    }
  }
  
  private func deselectTableViewCells() {
    guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
    for indexPath in selectedIndexPaths {
      tableView.deselectRow(at: indexPath, animated: false)
    }
  }
}

extension SelectQuestionGroupViewController: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    questionGroupCaretaker.questionGroups.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionGroupCell", for: indexPath) as? QuestionGroupCell else {
      assertionFailure()
      return UITableViewCell()
    }

    let questionGroup = questionGroupCaretaker.questionGroups[indexPath.row]
    cell.titleLabel.text = questionGroup.title
    cell.percentageSubscriber = questionGroup.score.$runningPercentage
      .receive(on: DispatchQueue.main)
      .map { String(format: "%.0f %%", round($0 * 100)) }
      .assign(to: \.text, on: cell.percentageLabel)
    return cell
  }
}

extension SelectQuestionGroupViewController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedQuestionGroup = questionGroupCaretaker.questionGroups[indexPath.row]
    return indexPath
  }

  open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    switch segue.destination {
    case let viewController as QuestionViewController:
      viewController.questionStrategy = AppSettings.shared.questionStrategy(for: questionGroupCaretaker)
      viewController.delegate = self
    case let navController as UINavigationController:
      guard let viewController = navController.topViewController as? CreateQuestionGroupViewController else {
        assertionFailure("Unexpected view controller type")
        return
      }
      viewController.delegate = self
    case _ as AppSettingsViewController:
      break
    default:
      assertionFailure("Unexpected segue destination: \(segue.destination)")
    }
  }
}

extension SelectQuestionGroupViewController: QuestionViewControllerDelegate {
  public func questionViewController(_ viewController: QuestionViewController, didCancel strategy: QuestionStrategy) {
    navigationController?.popToViewController(self, animated: true)
  }

  public func questionViewController(_ viewController: QuestionViewController, didComplete strategy: QuestionStrategy) {
    navigationController?.popToViewController(self, animated: true)
  }
}

extension SelectQuestionGroupViewController: CreateQuestionGroupViewControllerDelegate {
  public func createQuestionGroupViewControllerDidCancel(_ viewController: CreateQuestionGroupViewController) {
    dismiss(animated: true, completion: nil)
  }

  public func createQuestionGroupViewController(
      _ viewController: CreateQuestionGroupViewController,
      created questionGroup: QuestionGroup) {
    questionGroupCaretaker.questionGroups.append(questionGroup)
    questionGroupCaretaker.save()
    dismiss(animated: true, completion: nil)
    tableView.reloadData()
  }
}
