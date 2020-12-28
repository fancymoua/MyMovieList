

import UIKit

struct MovieDataAPI: Codable {
    var results: [MovieResult]
}

struct MovieResult: Codable {
    var id: Int
    var title: String
    var release_date: String?
    var poster_path: String?
}
