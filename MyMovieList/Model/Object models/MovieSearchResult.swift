

import UIKit

// used anywhere query for group of results is made
// currently includes user's search, person's credited work, and special collections list (i.e. trending movies)

struct MovieSearchResult: Codable, Hashable {
    var id: Int
    var title: String
    var poster_path: String?
    var imdbID: String?
    var popularity: Float?
    var media_type: String?
}
