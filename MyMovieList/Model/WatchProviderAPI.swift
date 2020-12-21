

import Foundation

struct WatchProviderAPI: Codable {
    var id: Int
    var results: Results
}

struct Results: Codable {
    var US: Region
}

struct Region: Codable {
    var link: String?
    var buy: [Provider]?
    var rent: [Provider]?
    var flatrate: [Provider]?
}

struct Provider: Codable {
    var logo_path: String
    var provider_id: Int
    var provider_name: String
}
