

import UIKit

struct WatchItem: Codable {
    
    var title: String
    var tmdbID: Int
    var posterPath: String
    
    init(title: String, tmdbID: Int, posterPath: String) {
        self.title = title
        self.tmdbID = tmdbID
        self.posterPath = posterPath
    }
    
}
