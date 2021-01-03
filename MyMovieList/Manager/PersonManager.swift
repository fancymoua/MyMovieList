

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
        
        print("baseURL is \(baseURL)")
        
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
                
                print("result cast is \(result.cast)")
                print("result crew is \(result.crew)")
                
                var castArray = [PersonModel]()
                var directorArray = [PersonModel]()
                
                for item in result.cast {
                    if item.order <= 3 {         // give me top 5
                        print(item.name)
                        let person = PersonModel(tmdbID: item.id, name: item.name, profilePath: item.profile_path)
                        castArray.append(person)
                    }
                }
                
                for item in result.crew {
                    if item.job == "Director" {
                        print(item.name)
                        let person = PersonModel(tmdbID: item.id, name: item.name, profilePath: item.profile_path)
                        directorArray.append(person)
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
