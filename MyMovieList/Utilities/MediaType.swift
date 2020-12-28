

import UIKit

enum MediaType {
    case Movie
    case TV
    
    var trendingURL: String {
        switch self {
        case .Movie:
            return "https://api.themoviedb.org/3/trending/movie/day?api_key=65db6bef59bff99c6a4504f0ce877ade"
        case .TV:
            return "https://api.themoviedb.org/3/trending/tv/day?api_key=65db6bef59bff99c6a4504f0ce877ade"
        }
    }
}
