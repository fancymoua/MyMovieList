
import UIKit

struct CastCrewAPI: Codable {
    var cast: [Cast]
    var crew: [Crew]
}

struct Cast: Codable {
    var id: Int
    var name: String
    var character: String?
    var profile_path: String?
    var order: Int
}

struct Crew: Codable {
    var name: String
    var job: String?
    var profile_path: String?
}
