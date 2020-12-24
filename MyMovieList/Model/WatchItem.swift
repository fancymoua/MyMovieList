

import UIKit

struct WatchItem: Codable {
    
    var title: String
    var tmdbID: Int
    var posterPath: String?
    var rating: String?
    
    init(title: String, tmdbID: Int, posterPath: String, rating: String) {
        self.title = title
        self.tmdbID = tmdbID
        self.posterPath = posterPath
        self.rating = rating
    }
    
}
