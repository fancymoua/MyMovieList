
import UIKit

// TMDB API

struct MovieDetailModel: Codable {
    var imdbID: String?
    var title: String?
    var release_date: String?
    var overview: String?
    var poster_path: String?
    var rated: String?
    var genres: String?
    var runtime: Int?
    var imdbRating: String?
}
