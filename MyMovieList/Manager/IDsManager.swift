

import UIKit

struct IDsManager: IdsManagerProtocol {
    
    static func getIMDBID(id: Int, type: MediaType, completion: @escaping (String)->Void) {
        
        var convertURL = String()
        
        // get IMDB ID
        if type == .Movie {
            convertURL = MediaType.Movie.baseURL + "\(id)" + "/external_ids?" + Constants.API.APIKey
        } else if type == .TV {
            convertURL = MediaType.TV.baseURL + "\(id)" + "/external_ids?" + Constants.API.APIKey
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
