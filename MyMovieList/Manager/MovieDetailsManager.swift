

import UIKit

class MovieDetailsManager {
    static var thisMovie = MovieDetailModel()
    
    static func getMovieDetails(movieTitle: String?, completed: @escaping (MovieDetailModel) -> Void) {
        let baseURL = "https://www.omdbapi.com/?apikey=1383769a&t="
        
        var movieEndpoint = String()
        
        if let title = movieTitle {
            let query = title.replacingOccurrences(of: " ", with: "+")
            movieEndpoint = baseURL + query
            
            print("This is movieEndpoint \(movieEndpoint)")
            
            guard let url = URL(string: movieEndpoint) else {
                print("Bad movieEndpoint")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let _ = error {
                    print("error making call to OMDB")
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Something other than 200 from OMDB")
                    return
                }
                
                guard let data = data else {
                    print("No data from OMDB")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieDetailModel.self, from: data)
                    
                    thisMovie = MovieDetailModel(imdbID: result.imdbID, Title: result.Title, Year: result.Year, Plot: result.Plot, Director: result.Director, Actors: result.Actors, Poster: result.Poster, Genre: result.Genre, imdbRating: result.imdbRating, Rated: result.Rated)
                    
                    completed(thisMovie)
         
                } catch {
                    print("Error getting movie details")
                }
            }
            task.resume()
        }
    }
}
