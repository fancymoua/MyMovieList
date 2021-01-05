
import Foundation

struct TVDetailAPI: Codable {
    var id: Int?
    var name: String?
    var first_air_date: String?
    var last_air_date: String?
    var overview: String?
    var poster_path: String?
    var status: String?         // either "Returning Series" or "Ended"
    var content_ratings: ContentResult?
    var genres: [Genre]?
    var number_of_seasons: Int?
    var number_of_episodes: Int?
}

struct ContentResult: Codable {
    var results: [RatingCountries]?
}

struct RatingCountries: Codable {
    var iso_3166_1: String?
    var rating: String?
}
