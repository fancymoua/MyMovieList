import UIKit

struct TVDetailModel: Codable {
    var name: String?
    var first_air_date: String?
    var last_air_date: String?
    var overview: String?
    var poster_path: String?
    var status: String?         // either "Returning Series" or "Ended"
    var contentRating: String?
    var genres: String?
    var seasonsCount: Int?
    var episodesCount: Int?
    var imdbID: String?
}
