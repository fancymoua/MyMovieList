import UIKit

// TMDB API

struct TVDetailModel: Codable {
    var name: String?
    var first_air_date: String?
    var last_air_date: String?
    var overview: String?
    var poster_path: String?
    var status: String?         // either "Returning Series" or "Ended"
}
