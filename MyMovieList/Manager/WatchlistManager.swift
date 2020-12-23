

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
    
    static func addToWatchlist(title: String, tmdbID: Int, posterPath: String) {
        
        var currentWatchlist = retrieveWatchlist()
        
        let newWatchItem = WatchItem(title: title, tmdbID: tmdbID, posterPath: posterPath)
        currentWatchlist.append(newWatchItem)
        
        do {
            let encoder = JSONEncoder()
            let encodedWatchlist = try encoder.encode(currentWatchlist)
            UserDefaults.standard.setValue(encodedWatchlist, forKey: "Watchlist")
        } catch {
            print("Could not set encodedWatchlist to userDefaults")
        }
    }
    
    static func checkIfAlreadyOnWatchlist(title: String) -> UIImage {
        
        let currentWatchlist = retrieveWatchlist()
        
        var image = UIImage()
        
        let filterForCurrentMovie = currentWatchlist.filter { $0.title == title }
        
        if filterForCurrentMovie.isEmpty {
            image = IconImages.heartUnfilled.image
        } else if !filterForCurrentMovie.isEmpty {
            image = IconImages.heartFilled.image
        }
        
        return image
    }
    
    static func updateWatchlistAfterDeletion(watchlist: [WatchItem]) {
        do {
            let encoder = JSONEncoder()
            let encodedWatchlist = try encoder.encode(watchlist)
            UserDefaults.standard.setValue(encodedWatchlist, forKey: "Watchlist")
        } catch {
            print("Could not set encodedWatchlist to userDefaults")
        }
    }
}
