

import Foundation

struct WatchProviderAPI: Codable {
    var US: Region
}

struct Region: Codable {
    var link: String
    var buy: [Provider]
    var ads: [Provider]
    var rent: [Provider]
}

struct Provider: Codable {
    var display_priority: Int
    var logo_path: String
    var provider_id: Int
    var provider_name: String
    
}
