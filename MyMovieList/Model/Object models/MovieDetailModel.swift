import UIKit

// OMDB API

struct MovieDetailModel: Codable {
    var imdbID: String?
    var Title: String?
    var Year: String?
    var Plot: String?
    var Writer: String?
    var Director: String?
    var Actors: String?
    var Poster: String?
    var Genre: String?
    var imdbRating: String?
    var Rated: String?
}
