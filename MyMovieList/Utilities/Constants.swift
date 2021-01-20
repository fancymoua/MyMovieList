

import Foundation

struct Constants {
    
    static let watchlistKey = "Watchlist"
    
    struct API {
        static let APIKey = "api_key=65db6bef59bff99c6a4504f0ce877ade"
        static let imageURL = "https://image.tmdb.org/t/p/"
        static let omdbAPIBaseURL = "https://www.omdbapi.com/?apikey=1383769a&i="
        static let personBaseURL = "https://api.themoviedb.org/3/person/"
        static let featuredDirector = "https://api.themoviedb.org/3/discover/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&region=US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_crew=525&watch_region=US"
    }
    struct Fonts {
        static let appFontRegular = "Avenir Next"
        static let appFontMedium = "Avenir Next Medium"
    }
}
