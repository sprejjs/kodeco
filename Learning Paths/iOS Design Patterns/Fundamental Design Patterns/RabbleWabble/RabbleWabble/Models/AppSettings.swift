//
// Created by Allan Spreys on 7/1/2023.
// Copyright (c) 2023 Razeware, LLC. All rights reserved.
//

import Foundation

public final class AppSettings {
  public static let shared = AppSettings()

  // Keys
  private struct Keys {
    static let questionStrategyType = "questionStrategy"
  }

  public var questionStrategyType: QuestionStrategyType {
    get {
      let rawValue = UserDefaults.standard.integer(forKey: Keys.questionStrategyType)
      return QuestionStrategyType(rawValue: rawValue) ?? .random
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: Keys.questionStrategyType)
    }
  }

  public func questionStrategy(for questionGroupCaretaker: QuestionGroupCaretaker) -> QuestionStrategy {
    questionStrategyType.questionStrategy(for: questionGroupCaretaker)
  }

  private init() {}
}

public enum QuestionStrategyType: Int, CaseIterable {
  case random
  case sequential

  public var title: String {
    switch self {
    case .random:
      return "Random"
    case .sequential:
      return "Sequential"
    }
  }

  public func questionStrategy(for questionGroupCaretaker: QuestionGroupCaretaker) -> QuestionStrategy {
    switch self {
    case .random:
      return RandomQuestionStrategy(questionGroupCaretaker: questionGroupCaretaker)
    case .sequential:
      return SequentialQuestionStrategy(questionGroupCaretaker: questionGroupCaretaker)
    }
  }
}