

import UIKit

struct TVDataAPI: Codable {
    var results: [TVResult]
}

struct TVResult: Codable {
    var id: Int
    var name: String
    var poster_path: String?
}

