/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Strategy
 - - - - - - - - - -
 ![Strategy Diagram](Strategy_Diagram.png)
 
 The strategy pattern defines a family of interchangeable objects.
 
 This pattern makes apps more flexible and adaptable to changes at runtime, instead of requiring compile-time changes.
 
 ## Code Example
 */

import UIKit

public protocol MovieRatingStrategy {
  var serviceName: String { get }

  func fetchRating(for movie: String, success: (_ rating: String, _ review: String) -> Void)
}

public final class RottenTomatoesService: MovieRatingStrategy {
  public let serviceName = "Rotten Tomatoes"

  public func fetchRating(for movie: String, success: (_ rating: String, _ review: String) -> Void) {
    // Make network request to Rotten Tomatoes API
    // ...
    // Call success block with rating and review
    success("95%", "Great!")
  }
}

public final class IMDBService: MovieRatingStrategy {
  public let serviceName = "IMDB"

  public func fetchRating(for movie: String, success: (_ rating: String, _ review: String) -> Void) {
    // Make network request to IMDB API
    // ...
    // Call success block with rating and review
    success("8.5", "Very Good!")
  }
}

public final class MovieRatingViewController: UIViewController {

  // MARK: - Instance Properties
  public var movieRatingService: MovieRatingStrategy?

  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()

    // Set the movie rating service
    movieRatingService = RottenTomatoesService()

    // Fetch the rating
    movieRatingService?.fetchRating(for: "The Matrix") { rating, review in
      print("Rating: \(rating), Review: \(review)")
    }
  }
}