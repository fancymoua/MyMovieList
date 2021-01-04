import UIKit

struct CreditedWorkResult: Codable, Hashable {
    var id: Int
    var title: String
    var poster_path: String?
    var imdbID: String?
    var popularity: Float?
    var media_type: String?
    var character: String?
    var job: String?
}
