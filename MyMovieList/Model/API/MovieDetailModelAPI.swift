import UIKit

// TMDB API

struct MovieDetailModelAPI: Codable {
    var id: Int?
    var imdb_id: String?
    var title: String?
    var release_date: String?
    var overview: String?
    var poster_path: String?
    var releases: Countries?
    var genres: [Genre]?
    var runtime: Int?
}

// ratings i.e. PG-13, R, etc.
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
