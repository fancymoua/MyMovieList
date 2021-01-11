

import Foundation

@testable import MyMovieList

class MockIDManager {
    
    static var shouldReturnError = false
    
    
}

extension MockIDManager: IdsManagerProtocol {
    static func getIMDBID(id: Int, type: MediaType, completion: @escaping (String) -> Void) {
        
        let imdbID =  "tt8206668"
//        let imdbID = ""
        
        if shouldReturnError {
            print("There was an error???")
        } else {
            completion(imdbID)
        }
        
    }
}
