

import XCTest
@testable import MyMovieList

class MyMovieListTests: XCTestCase {
    
    let dateTimeFormatter = DateTimeFormattingManager()
    
    func test_valid_year() {
        
        let wholeDate = "1991-10-10"
        
        let correctYear = "1991"
        
        DateTimeFormattingManager.formatYear(dateString: wholeDate) { (returnedYear) in
            
            XCTAssertEqual(returnedYear, correctYear)
        }
    }
    
    func test_valid_conversion_runtime() {
        let minutes = 159
        
        let correctTime = (hours: 2, leftMinutes: 39)
        
        let result = DateTimeFormattingManager.minutesToHoursAndMinutes(minutes)
        
        let resultHour = result.hours
        let resultMinutesLeft = result.leftMinutes
        
        XCTAssertEqual(resultHour, correctTime.hours)
        XCTAssertEqual(resultMinutesLeft, correctTime.leftMinutes)
    }

}
