

import Foundation

struct PersonManager {
    
    static var castCrewArray = [PersonModel]()
    
    static func getCastCrewInfo(tmdbiD: Int, mediaType: MediaType, completed: @escaping ([PersonModel], [PersonModel])-> Void) {
        
        var baseURL = String()
        
        if mediaType == .Movie {
            baseURL = MediaType.Movie.castCrewBaseURL + "\(tmdbiD)" + "/credits?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US"
        } else if mediaType == .TV {
            baseURL = MediaType.TV.castCrewBaseURL + "\(tmdbiD)" + "/credits?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US"
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
    
    static func getPersonDetail(tmdbID: Int, completed: @escaping (PersonModel)-> Void) {
        
        let endpoint = "https://api.themoviedb.org/3/person/" + "\(tmdbID)" + "?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US"
        
        guard let url = URL(string: endpoint) else {
            print("Bad person detail url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("Error making call - getPersonDetail")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Get person detail -- something other than 200")
                return
            }
            
            guard let data = data else {
                print("getPersonDetail -- no data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(PersonModel.self, from: data)
                
                completed(result)
            } catch {
                print("Error decoding personDetail")
            }
            
        }
        
        task.resume()
    
    }
    
    static func getPersonCreditedWork(tmdbID: Int, completed: @escaping ([CreditedWorkResult])->Void) {
        
        let endpoint = "https://api.themoviedb.org/3/person/" + "\(tmdbID)" + "/combined_credits?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US"
        
        guard let url = URL(string: endpoint) else {
            print("getPersonCreditedWork -- bad url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("Error making call -- get credited work")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Something other than 200 -- get credited work")
                return
            }
            
            guard let data = data else {
                print("get credited -- no data")
                return
            }
            
            do {
                var sumArray = [CreditedWorkResult]()
                
                let decoder = JSONDecoder()
                let result = try decoder.decode(PersonCreditedWorkAPI.self, from: data)
                
                if let castArray = result.cast {
                    
                    for item in castArray {
                        
                        if item.poster_path != nil && !CreditedWorkFilter.talkShows.values.contains(item.id) && item.adult == false {
                            
                            let newItem = CreditedWorkResult(id: item.id, title: item.title ?? item.name ?? "no title", poster_path: item.poster_path, popularity: item.popularity, media_type: item.media_type)
                            sumArray.append(newItem)
                        }
                    }
                }
                
                if let crewArray = result.crew {
                    
                    for item in crewArray {
                        
                        if item.poster_path != nil && !CreditedWorkFilter.talkShows.values.contains(item.id) {
                            
                            let newItem = CreditedWorkResult(id: item.id, title: item.title ?? item.name ?? "no title", poster_path: item.poster_path, popularity: item.popularity, media_type: item.media_type)
                            sumArray.append(newItem)
                        }
                    }
                }
                
                let sortedByPop = sumArray.sorted(by: { $0.popularity! > $1.popularity! })
                var noRepeats = [CreditedWorkResult]()
                
                for item in sortedByPop {
                    if !noRepeats.contains(item) {
                        noRepeats.append(item)
                    }
                }

                completed(noRepeats)
            } catch {
                print("nah")
            }
            
        }
        
        task.resume()
    }
    
}
