

import UIKit

struct PersonCreditedWorkAPI: Codable {
    var id: Int
    var cast: [WorkItem]
    var crew: [WorkItem]
}

struct WorkItem: Codable {
    var id: Int
    var title: String
    var media_type: String      // movie or tv
    var poster_path: String
}
