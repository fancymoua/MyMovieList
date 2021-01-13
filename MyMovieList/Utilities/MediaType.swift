

import UIKit

enum MediaType {
    case Movie
    case TV
    
    var baseURL: String {
        switch self {
        case .Movie:
            return "https://api.themoviedb.org/3/movie/"
        case .TV:
            return "https://api.themoviedb.org/3/tv/"
        }
    }
    
    var trendingURL: String {
        switch self {
        case .Movie:
            return "https://api.themoviedb.org/3/trending/movie/day?api_key=65db6bef59bff99c6a4504f0ce877ade"
        case .TV:
            return "https://api.themoviedb.org/3/trending/tv/day?api_key=65db6bef59bff99c6a4504f0ce877ade"
        }
    }
    
    var searchBaseURL: String {
        switch self {
        case .Movie:
            return "https://api.themoviedb.org/3/search/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&query="
        case .TV:
            return "https://api.themoviedb.org/3/search/tv?api_key=65db6bef59bff99c6a4504f0ce877ade&query="
        }
    }
    
    var detailBaseURL: String {
        switch self {
        case .Movie:
            return "https://api.themoviedb.org/3/movie/"
        case .TV :
            return "https://api.themoviedb.org/3/tv/"
        }
    }
    
    var castCrewBaseURL: String {
        switch self {
        case .Movie:
            return "https://api.themoviedb.org/3/movie/"
        case .TV:
            return "https://api.themoviedb.org/3/tv/"
        }
    }
}
