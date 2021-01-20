

import Foundation

// keywords that populate the collection view of genres on landing

struct LandingKeywords {
    static let keywords = [
        "Comedy": "https://api.themoviedb.org/3/discover/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&region=US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=35",
        "Romance":"https://api.themoviedb.org/3/discover/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&region=US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=10749&watch_region=US",
        "On Netflix": "https://api.themoviedb.org/3/discover/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&region=US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_providers=8&watch_region=US",
        "Horror": "https://api.themoviedb.org/3/discover/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&region=US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=27",
        "Documentary": "https://api.themoviedb.org/3/discover/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&region=US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=99",
        "Family": "https://api.themoviedb.org/3/discover/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&region=US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=10751",
    ]
}
