

import UIKit

struct MovieDataAPI: Codable {
    var results: [Result]
}

struct Result: Codable {
    var title: String
    var release_date: String
    var poster_path: String?
}
