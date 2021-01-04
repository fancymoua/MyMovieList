

import UIKit

struct PersonCreditedWorkAPI: Codable {
    var cast: [WorkItem]?
    var crew: [WorkItem]?
    var id: Int
}

struct WorkItem: Codable {
    var id: Int
    var title: String?
    var name: String?
    var media_type: String?      // movie or tv
    var poster_path: String?
}
