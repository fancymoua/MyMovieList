import XCTest
@testable import MyMovieList

class IDsManagerTests: XCTestCase {
    
//    func testGreeting() {
//        let greeting = "Hello"
//
//        XCTAssertNotNil(greeting)
//    }
    
    func test_valid_IMDBID() {
        
        print("Hello")
        
        let tmdbID = 88
        
        let correctIMDBID = "tt2543163"
        
        let mediaType = MediaType.Movie
        
        IDsManager.getIMDBID(id: tmdbID, type: mediaType) { (returnedID) in
            self.waitForExpectations(timeout: 5, handler: nil)
            print("returned id \(returnedID)")
//            XCTAssertEqual(correctIMDBID, returnedID)
        }
        
        print("Hello2")
    }
    
    func test_movie_details() {
        let tmdbID = 88
        
        MovieDetailsManager.getMovieDetails(tmdbID: tmdbID, mediaType: .Movie) { (daMovie) in
            print("damovie is \(daMovie)")
        }
    }
    
}
