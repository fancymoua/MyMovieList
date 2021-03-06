

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
    var popularity: Float?
    var media_type: String?      // movie or tv
    var poster_path: String?
    var character: String?
    var job: String?
    var adult: Bool?
}
