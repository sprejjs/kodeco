/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import XCTest
import Combine
@testable import Networker

final class MockNetworker: Networking {
  var delegate: NetworkingDelegate?

  func fetch(_ request: Request) -> AnyPublisher<Data, URLError> {
    let output: Data
    switch request {
    case is ArticleRequest:
      let article = Article(
        name: "Article Name",
        description: "Article Description",
        image: URL(string: "https://image.com")!,
        id: "Article ID",
        downloadedImage: nil)
      let articleData = ArticleData(article: article)
      let articles = Articles(data: [articleData])
      output = try! JSONEncoder().encode(articles)
    default:
      output = Data()
    }

    return Just(output)
      .setFailureType(to: URLError.self)
      .eraseToAnyPublisher()
  }
}

final class ArticlesViewModelTests: XCTestCase {
  // swiftlint:disable:next implicitly_unwrapped_optional
  var viewModel: ArticlesViewModel!
  var cancellables: Set<AnyCancellable> = []

  override func setUpWithError() throws {
    try super.setUpWithError()
    viewModel = ArticlesViewModel(networker: MockNetworker())
  }

  func testArticlesAreFetchedCorrectly() {
    XCTAssert(viewModel.articles.isEmpty)
    let expectation = XCTestExpectation(description: "Article received")

    viewModel.$articles.sink { articles in
      guard !articles.isEmpty else {
        return
      }
      XCTAssertEqual(articles[0].id, "Article ID")
      expectation.fulfill()
    }
    .store(in: &cancellables)

    viewModel.fetchArticles()

    wait(for: [expectation], timeout: 1)
  }
}
