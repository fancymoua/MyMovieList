

import UIKit

// Get movie/tv details, get watch providers, and get IMDB rating

class MovieDetailsManager {
    
    static func getMovieDetails(tmdbID: Int, mediaType: MediaType, completed: @escaping (MovieDetailModel) -> Void) {
        
        let baseURL = MediaType.Movie.detailBaseURL + "\(tmdbID)?" + Constants.API.APIKey + "&language=en-US&append_to_response=releases"
        
        guard let url = URL(string: baseURL) else {
            print("Bad movieEndpoint")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("error making call to tmdb")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Something other than 200 from tmdb")
                return
            }
            
            guard let data = data else {
                print("No data from OMDB")
                return
            }
            
            var rated = String()
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MovieDetailModelAPI.self, from: data)
                
                if let bacon = result.releases?.countries {
                    for item in bacon {
                        if item.iso_3166_1 == "US" {
                            rated = item.certification ?? "no rated"
                        }
                    }
                }
                
                var genreNames = [String]()
                
                if let genres = result.genres {
                    for item in genres {
                        if let name = item.name {
                            genreNames.append(name)
                        }
                    }
                }
                
                let genreJoined = genreNames.joined(separator: ", ")
                
                getIMDBRating(imdbID: result.imdb_id!) { (ratingModel) in
                    let rating = ratingModel.imdbRating
                    
                    let thisMovie = MovieDetailModel(tmdbID: result.id ,imdbID: result.imdb_id, title: result.title, release_date: result.release_date, overview: result.overview, poster_path: result.poster_path, rated: rated, genres: genreJoined, runtime: result.runtime, imdbRating: rating)
      
                    completed(thisMovie)
                }
            } catch {
                print("Error getting movie details")
            }
        }
        task.resume()
    }
    
    static func getTVDetails(tmdbID: Int, mediaType: MediaType, completed: @escaping (TVDetailModel) -> Void) {
        
        let baseURL = MediaType.TV.detailBaseURL + "\(tmdbID)?" + Constants.API.APIKey + "&language=en-US&append_to_response=content_ratings"
        
        guard let url = URL(string: baseURL) else {
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
                let result = try decoder.decode(TVDetailAPI.self, from: data)
                
                var thisRating = String()
                
                if let contentRatings = result.content_ratings?.results {
                    for item in contentRatings {
                        if item.iso_3166_1 == "US" {
                            thisRating = item.rating ?? "not rated"
                        } else {
                            thisRating = "not rated"
                        }
                    }
                } else {
                    thisRating = "Not rated"
                }
                
                var genreNames = [String]()
                
                if let genres = result.genres {
                    for item in genres {
                        if let name = item.name {
                            genreNames.append(name)
                        }
                    }
                }
                
                let genreJoined = genreNames.joined(separator: ", ")
                
                var runningYears = String()
                
                var firstAirYear = String()
                var lastAirYear = String()
                
                if let firstAirDate = result.first_air_date {
                    DateTimeFormattingManager.formatYear(dateString: firstAirDate) { (year) in
                        firstAirYear = year
                    }
                } else { firstAirYear = ""}

                if let lastAirDate = result.last_air_date {
                    DateTimeFormattingManager.formatYear(dateString: lastAirDate) { (year) in
                        lastAirYear = year
                    }
                } else {lastAirYear = ""}

                if result.status == "Ended" {
                    runningYears = "\(firstAirYear) - \(lastAirYear)"
                } else if result.status == "Returning Series" {
                    runningYears = "\(firstAirYear) -"
                }
                
                // get IMDBId, then get IMDBRating, then create TVDetailModel object
                IDsManager.getIMDBID(id: result.id! , type: .TV) { (daIMDBID) in
                    getIMDBRating(imdbID: daIMDBID) { (ratingModel) in
                        let rating = ratingModel.imdbRating
                        
                        let thisMovie = TVDetailModel(tmdbID: result.id ,name: result.name, yearAired: runningYears ,overview: result.overview, poster_path: result.poster_path, status: result.status, contentRating: thisRating, genres: genreJoined, seasonsCount: result.number_of_seasons, episodesCount: result.number_of_episodes, imdbID: daIMDBID, imdbRating: rating)
                        
                        completed(thisMovie)
                    }
                }
            } catch {
                print("Error getting movie details")
            }
        }
        task.resume()
    }
    
    static func getWatchProviders(tmdbID: Int?, mediaType: MediaType, completed: @escaping ([WatchProviders]) -> Void) {
        
        var providerArray = [WatchProviders]()
        
        if let id = tmdbID {
            
            var endpoint = String()
            
            if mediaType == .Movie {
                endpoint = MediaType.Movie.baseURL + "\(id)" + "/watch/providers?" + Constants.API.APIKey
            } else if mediaType == .TV {
                endpoint = MediaType.TV.baseURL + "\(id)" + "/watch/providers?" + Constants.API.APIKey
            }
            
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
                            if item.provider_id == WatchProviders.HBOMax.id { providerArray.append(.HBOMax) }
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
    
    static func getIMDBRating(imdbID: String, completion: @escaping (RatingModel)->Void) {
        let baseURL = Constants.API.omdbAPIBaseURL + "\(imdbID)"
        
        guard let url = URL(string: baseURL) else {
            print("bad getIMDBRating URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                print("Error making call getIMDBRatingURL")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Something other than 200 -- getIMDBRating")
                return
            }
            
            guard let data = data else {
                print("No data -- get IMDBRating")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let result = try decoder.decode(RatingsAPI.self, from: data)
                
                let thisRating = RatingModel(imdbRating: result.imdbRating)
                completion(thisRating)
            } catch {
                print("Catch: could not complete getIMDBRating")
            }
        }
        task.resume()
    }
    
    static func getCastCrewInfo(tmdbiD: Int, mediaType: MediaType, completed: @escaping ([PersonModel], [PersonModel])-> Void) {
        
        var baseURL = String()
        
        if mediaType == .Movie {
            baseURL = MediaType.Movie.castCrewBaseURL + "\(tmdbiD)" + "/credits?" + Constants.API.APIKey + "&language=en-US"
        } else if mediaType == .TV {
            baseURL = MediaType.TV.castCrewBaseURL + "\(tmdbiD)" + "/credits?" + Constants.API.APIKey + "&language=en-US"
        }
        
        guard let url = URL(string: baseURL) else {
            print("getCastCrew: bad URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("getCastCrew -- error making call")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("getCastCrew -- something other than 200 returned")
                return
            }
            
            guard let data = data else {
                print("getCastCrew -- no data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(CastCrewAPI.self, from: data)
                
                var castArray = [PersonModel]()
                var directorArray = [PersonModel]()
                
                for item in result.cast {
                    if item.order <= 3 {         // give me top
                        let person = PersonModel(id: item.id, name: item.name, profile_path: item.profile_path)
                        castArray.append(person)
                    }
                }
                
                for item in result.crew {
                    switch mediaType {
                    case .Movie:
                        if item.job == "Director" {
                            let person = PersonModel(id: item.id, name: item.name, profile_path: item.profile_path)
                            directorArray.append(person)
                        }
                    case .TV:
                        if item.job == "Executive Producer" {
                            let person = PersonModel(id: item.id, name: item.name, profile_path: item.profile_path)
                            directorArray.append(person)
                        }
                    }
                }
                completed(castArray, directorArray)
            } catch {
                print("Something went wrong getting castCrew")
            }
            
        }
        
        task.resume()
    }
    
}
