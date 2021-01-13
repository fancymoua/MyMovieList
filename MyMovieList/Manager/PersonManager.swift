

import Foundation

struct PersonManager {
    
    static func getPersonDetail(tmdbID: Int, completed: @escaping (PersonModel)-> Void) {
        
        let endpoint = Constants.API.personBaseURL + "\(tmdbID)?" + Constants.API.APIKey + "&language=en-US"
        
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
        
        let endpoint = Constants.API.personBaseURL + "\(tmdbID)" + "/combined_credits?" + Constants.API.APIKey
        
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
                        
                        // don't include items that are talk shows, porn, or missing poster images
                        if item.poster_path != nil && !CreditedWorkFilter.talkShows.values.contains(item.id) && item.adult == false {
                            
                            // movies have "title", shows have "name"
                            let newItem = CreditedWorkResult(id: item.id, title: item.title ?? item.name, poster_path: item.poster_path, popularity: item.popularity, media_type: item.media_type)
                            sumArray.append(newItem)
                        }
                    }
                }
                
                if let crewArray = result.crew {
                    
                    for item in crewArray {
                        
                        // don't include items that are talk shows, porn, or missing poster images
                        if item.poster_path != nil && !CreditedWorkFilter.talkShows.values.contains(item.id) && item.adult == false {
                            
                            // movies have "title", shows have "name"
                            let newItem = CreditedWorkResult(id: item.id, title: item.title ?? item.name, poster_path: item.poster_path, popularity: item.popularity, media_type: item.media_type)
                            sumArray.append(newItem)
                        }
                    }
                }
                
                // sorting my popularity and removing repeats
                let sortedByPop = sumArray.sorted(by: { $0.popularity! > $1.popularity! })
                var noRepeats = [CreditedWorkResult]()
                
                for item in sortedByPop {
                    if !noRepeats.contains(item) {
                        noRepeats.append(item)
                    }
                }

                completed(noRepeats)
            } catch {
                print("Could not decode PersonCreditedWorkAPI")
            }
            
        }
        
        task.resume()
    }
    
}
