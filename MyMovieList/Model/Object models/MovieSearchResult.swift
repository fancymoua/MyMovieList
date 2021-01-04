

import UIKit

struct MovieSearchResult: Codable, Hashable {
    var id: Int
    var title: String
    var poster_path: String?
    var imdbID: String?
    var popularity: Float?
}
