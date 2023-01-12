//
// Created by Allan Spreys on 9/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import Foundation

public final class QuestionBuilder {
  public var answer: String?
  public var hint: String?
  public var prompt: String?

  public func build() throws -> Question {
    guard let answer = answer, !answer.isEmpty else {
      throw Error.missingAnswer
    }

    guard let prompt = prompt, !prompt.isEmpty else {
      throw Error.missingPrompt
    }

    return Question(answer: answer, hint: hint, prompt: prompt)
  }

  public enum Error: Swift.Error {
    case missingAnswer
    case missingPrompt
  }
}

public final class QuestionGroupBuilder {
  public private(set) var questions: [QuestionBuilder] = []
  public var title: String?

  public func addNewQuestion() {
    questions.append(.init())
  }

  public func removeQuestion(at index: Int) {
    questions.remove(at: index)
  }

  public func build() throws -> QuestionGroup {
    guard let title = title, !title.isEmpty else {
      throw Error.missingTitle
    }

    guard !questions.isEmpty else {
      throw Error.missingQuestions
    }

    return QuestionGroup(questions: questions.compactMap { try? $0.build() } , title: title)
  }

  public enum Error: Swift.Error {
    case missingTitle
    case missingQuestions
  }
}
