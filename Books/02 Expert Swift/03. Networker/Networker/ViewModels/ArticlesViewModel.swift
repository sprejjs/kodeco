/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI
import Combine

final class ArticlesViewModel: ObservableObject {
  @Published private(set) var articles: [Article] = []

  private var cancellables: Set<AnyCancellable> = []
  private var networker: Networking

  init(networker: Networking = Networker()) {
    self.networker = networker
    self.networker.delegate = self
  }

  func fetchArticles() {
    let request = ArticleRequest()
    networker.fetch(request)
      .tryMap([Article].init)
      .replaceError(with: [])
      .sink { [unowned self] in
        self.articles = $0
      }
      .store(in: &cancellables)
  }

  func fetchImage(for article: Article) {
    guard let index = articles.firstIndex(where: { $0.id == article.id }) else {
      return
    }

    let request = ImageRequest(url: article.image)

    networker.fetchWithCache(request)
      .replaceError(with: UIImage())
      .sink { [weak self] image in
        self?.articles[index].downloadedImage = image
      }
      .store(in: &cancellables)
  }
}

extension ArticlesViewModel: NetworkingDelegate {
  func headers(for networking: Networking) -> [String : String] {
    return ["Content-Type": "application/vnd.api+json; charset=utf-8"]
  }

  func networking(
    _ networking: Networking,
    transformPublisher publisher: AnyPublisher<Data, URLError>
  ) -> AnyPublisher<Data, URLError> {
    publisher.receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
}
