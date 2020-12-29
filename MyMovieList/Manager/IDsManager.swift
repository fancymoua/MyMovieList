

import UIKit

struct IDsManager {
    static func getIMDBID(id: Int, type: MediaType, completion: @escaping (String)->Void) {
        
        var convertURL = String()
        
        // get IMDB ID
        if type == .Movie {
            convertURL = "https://api.themoviedb.org/3/movie/" + "\(id)" + "/external_ids?api_key=65db6bef59bff99c6a4504f0ce877ade"
        } else if type == .TV {
            convertURL = "https://api.themoviedb.org/3/tv/" + "\(id)" + "/external_ids?api_key=65db6bef59bff99c6a4504f0ce877ade"
        }
        
        guard let url = URL(string: convertURL) else {
            print("Bad convert URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("Cow -- error making call")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Cow -- something other than 200")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MovieIDAPI.self, from: data)
                let daID = result.imdb_id
                completion(daID)
            } catch {
                print("Couldn't get IMDB ID")
            }
            
        }
        task.resume()
    }
}
