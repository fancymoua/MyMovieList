

import UIKit

class MovieDetailsManager {
    static var thisMovie = MovieDetailModel()
//    static var providerArray = [WatchProviders]()
    
    static func getMovieDetails(imdbID: String?, completed: @escaping (MovieDetailModel) -> Void) {
        let baseURL = "https://www.omdbapi.com/?apikey=1383769a&i="
        
        var movieEndpoint = String()
        
        if let imdbID = imdbID {
            movieEndpoint = baseURL + imdbID
            
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
                    
                    thisMovie = MovieDetailModel(imdbID: result.imdbID, Title: result.Title, Year: result.Year, Plot: result.Plot, Writer: result.Writer, Director: result.Director, Actors: result.Actors, Poster: result.Poster, Genre: result.Genre, imdbRating: result.imdbRating, Rated: result.Rated)
                    
                    completed(thisMovie)
         
                } catch {
                    print("Error getting movie details")
                }
            }
            task.resume()
        }
    }
    
    static func getWatchProviders(tmdbID: Int?, completed: @escaping ([WatchProviders]) -> Void) {
        
        var providerArray = [WatchProviders]()
        
        if let id = tmdbID {
            let endpoint = "https://api.themoviedb.org/3/movie/" + "\(id)" + "/watch/providers?api_key=65db6bef59bff99c6a4504f0ce877ade"
            
            guard let url = URL(string: endpoint) else {
                print("bad watch provider URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let _ = error {
                    print("Error making call to watch provider endpoint")
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Something other than 200 returned from watch provider endpoint")
                    return
                }
                
                guard let data = data else {
                    print("No data from watch provider endpoint")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    
                    let allData = try decoder.decode(WatchProviderAPI.self, from: data)
                    
                    let results = allData.results.US
                    
                    if let safeFlatrate = results.flatrate {
                        for item in safeFlatrate {
                            if item.provider_id == WatchProviders.Netflix.id { providerArray.append(.Netflix) }
                            if item.provider_id == WatchProviders.DisneyPlus.id { providerArray.append(.DisneyPlus) }
                            if item.provider_id == WatchProviders.Hulu.id { providerArray.append(.Hulu) }
                            if item.provider_id == WatchProviders.AmazonPrime.id { providerArray.append(.AmazonPrime) }
                            if item.provider_id == WatchProviders.HBONow.id { providerArray.append(.HBONow) }
                        }
                    }
                    
                    if let safeRent = results.rent {
                        for item in safeRent {
                            if item.provider_id == WatchProviders.AmazonVideoRent.id { providerArray.append(.AmazonVideoRent) }
                        }
                    }
                    
                    if let safeBuy = results.buy {
                        for item in safeBuy {
                            if item.provider_id == WatchProviders.AmazonVideoBuy.id { providerArray.append(.AmazonVideoBuy) }
                            if item.provider_id == WatchProviders.AppleITunes.id { providerArray.append(.AppleITunes) }
                        }
                    }
                    
                    completed(providerArray)
                } catch {
                    print("Could not decode watch provider data")
                }
            }
            task.resume()
        }
    }
    
}
