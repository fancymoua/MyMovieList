

import Foundation

struct DateTimeFormattingManager {
    static func formatYear(dateString: String, completion: (String)->Void) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-mm-dd"
        guard let date = dateFormatter.date(from: dateString) else {return}
        
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        completion(year)
    }
    
    static func minutesToHoursAndMinutes (_ minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
}
