//
// Created by Allan Spreys on 8/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import Foundation

public final class QuestionGroupCaretaker {
  public let fileName = "QuestionGroupData"
  public var questionGroups: [QuestionGroup] = []
  public var selectedQuestionGroup: QuestionGroup!

  public init() {
    loadQuestionGroups()
  }

  private func loadQuestionGroups() {
    if let questionGroups = try? DiskCaretaker.shared.load(fileName) as [QuestionGroup] {
      self.questionGroups = questionGroups
      return
    }

    let bundle = Bundle.main
    let url = bundle.url(forResource: fileName, withExtension: "json")!
    self.questionGroups = try! DiskCaretaker.shared.load(url) as [QuestionGroup]
    try! save()
  }

  public func save() {
    do {
      try DiskCaretaker.shared.save(questionGroups, to: fileName)
    } catch (let error) {
      assertionFailure(error.localizedDescription)
      print("Couldn't save question groups: \(error)")
    }
  }
}