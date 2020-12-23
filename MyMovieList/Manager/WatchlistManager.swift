

import UIKit

struct WatchlistManager {
    
    static func retrieveWatchlist() -> [WatchItem] {
        
        var itemsArray = [WatchItem]()
        
        if let watchlistRaw = UserDefaults.standard.object(forKey: "Watchlist") as? Data {
            do {
                let decoder = JSONDecoder()
                itemsArray = try decoder.decode([WatchItem].self, from: watchlistRaw)
            } catch {
                print("Couldn't decode watchlistItem")
            }
        } else {
            print("watchlist is empty!")
            itemsArray = []
        }
        
        return itemsArray
    }
}
