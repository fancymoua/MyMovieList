

import UIKit

// used in user's search results + special collection results

struct TVDataAPI: Codable {
    var results: [TVResult]?
}

struct TVResult: Codable {
    var id: Int?
    var name: String?
    var poster_path: String?
    var media_type: String?
}

