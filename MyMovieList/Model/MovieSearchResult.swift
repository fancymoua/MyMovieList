

import UIKit

struct MovieSearchResult: Codable, Hashable {
    var id: Int
    var title: String
    var release_date: String?
    var poster_path: String?
}
