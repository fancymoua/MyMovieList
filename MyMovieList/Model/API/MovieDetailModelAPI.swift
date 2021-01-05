import UIKit

// TMDB API

struct MovieDetailModelAPI: Codable {
    var imdbID: String?
    var title: String?
    var release_date: String?
    var overview: String?
    var poster_path: String?
    var releases: Countries?
    var genres: [Genre]?
}

struct Countries: Codable {
    var countries: [Certification]
}

struct Certification: Codable {
    var certification: String?
    var iso_3166_1: String?     // country
}

struct Genre: Codable {
    var id: Int
    var name: String
}