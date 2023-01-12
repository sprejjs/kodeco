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

public protocol  QuestionViewControllerDelegate: AnyObject {
  func questionViewController(_ viewController: QuestionViewController, didCancel strategy: QuestionStrategy)
  func questionViewController(_ viewController: QuestionViewController, didComplete strategy: QuestionStrategy)
}

public class QuestionViewController: UIViewController {

  // MARK: - Instance Properties
  public weak var delegate: QuestionViewControllerDelegate?
  public var questionStrategy: QuestionStrategy? {
    didSet {
      navigationItem.title = questionStrategy?.title
    }
  }

  public var questionView: QuestionView! {
    guard isViewLoaded else { return nil }
    return (view as! QuestionView)
  }

  private lazy var backButton: UIBarButtonItem = { [unowned self] in
    let button = UIBarButtonItem(
        image: UIImage(named: "ic_menu"),
        style: .plain,
        target: self,
        action: #selector(backButtonPressed))
    return button
  }()

  private let questionIndexItem: UIBarButtonItem = UIBarButtonItem(
      title: "",
      style: .plain,
      target: nil,
      action: nil)
  
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    showQuestion()
  }

  private func setupNavigationBar() {
    navigationItem.leftBarButtonItem = backButton
    navigationItem.rightBarButtonItem = questionIndexItem
  }

  @objc private func backButtonPressed() {
    guard let strategy = questionStrategy else { return }

    delegate?.questionViewController(self, didCancel: strategy)
  }
  
  private func showQuestion() {
    guard let question = questionStrategy?.currentQuestion() else {
      assertionFailure("Invalid question index")
      return
    }

    questionIndexItem.title = questionStrategy?.questionIndexTitle()

    questionView.answer.text = question.answer
    questionView.prompt.text = question.prompt
    questionView.hint.text = question.hint

    questionView.answer.isHidden = true
    questionView.hint.isHidden = true
  }
  
  // MARK: - Actions
  @IBAction func toggleAnswerLabels(_ sender: Any) {
    [questionView.answer, questionView.hint].forEach { $0.isHidden.toggle() }
  }
  
  @IBAction func handleCorrect(_ sender: Any) {
    guard let questionStrategy = questionStrategy else { return }

    questionStrategy.markQuestionCorrect(questionStrategy.currentQuestion())
    questionView.correctCount.text = "\(questionStrategy.correctCount)"
    showNextQuestion()
  }
  
  @IBAction func handleIncorrect(_ sender: Any) {
    guard let questionStrategy = questionStrategy else { return }

    questionStrategy.markQuestionIncorrect(questionStrategy.currentQuestion())
    questionView.incorrectCount.text = "\(questionStrategy.incorrectCount)"
    showNextQuestion()
  }

  private func showNextQuestion() {
    if questionStrategy?.advanceToNextQuestion() == true {
      showQuestion()
    } else {
      guard let strategy = questionStrategy else { return }
      delegate?.questionViewController(self, didComplete: strategy)
    }
  }
}