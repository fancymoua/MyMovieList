import XCTest
@testable import MyMovieList

class IDsManagerTests: XCTestCase {
    
//    let mockIDManager = MockIDManager()
    
//    func testGreeting() {
//        let greeting = "Hello"
//
//        XCTAssertNotNil(greeting)
//    }
    
    func test_valid_IMDBID() {
        
        let expectedID = "tt8206668"
        
        MockIDManager.getIMDBID(id: 530723, type: .Movie) { (cowID) in
            print("cowiD is \(cowID)")
            XCTAssertEqual(cowID, expectedID)
        }
      
    }
    
}
