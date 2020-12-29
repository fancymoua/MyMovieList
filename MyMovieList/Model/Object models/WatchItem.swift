

import UIKit

struct WatchItem: Codable {
    
    var title: String
    var tmdbID: Int
    var posterPath: String?
    var rating: String?
    var rated: String?
    var year: String?
    var imdbID: String?
    var mediaType: String?
    
    init(title: String, tmdbID: Int, posterPath: String, rating: String, rated: String, year: String, imdbID: String, mediaType: String) {
        self.title = title
        self.tmdbID = tmdbID
        self.posterPath = posterPath
        self.rating = rating
        self.rated = rated
        self.year = year
        self.imdbID = imdbID
        self.mediaType = mediaType
    }
    
}
