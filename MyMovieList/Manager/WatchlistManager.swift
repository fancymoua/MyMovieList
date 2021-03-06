

import UIKit

struct WatchlistManager {
    
    static func retrieveWatchlist(completed: @escaping ([WatchItem])->Void){
        
        var itemsArray = [WatchItem]()
        
        if let watchlistRaw = UserDefaults.standard.object(forKey: Constants.watchlistKey) as? Data {
            do {
                let decoder = JSONDecoder()
                itemsArray = try decoder.decode([WatchItem].self, from: watchlistRaw)
                completed(itemsArray)
            } catch {
                print("Couldn't decode watchlistItem")
            }
        } else {
            print("watchlist is empty!")
            itemsArray = []
            completed(itemsArray)
        }
    }
    
    static func addToWatchlist(title: String, tmdbID: Int, posterPath: String, rating: String, year: String, rated: String, imdbID: String, mediaType: String) {
        
        var currentWatchlist = [WatchItem]()
        retrieveWatchlist { (watchlist) in
            currentWatchlist = watchlist
            
            let newWatchItem = WatchItem(title: title, tmdbID: tmdbID, posterPath: posterPath, rating: rating, rated: rated, year: year, mediaType: mediaType)
            currentWatchlist.append(newWatchItem)
            
            do {
                let encoder = JSONEncoder()
                let encodedWatchlist = try encoder.encode(currentWatchlist)
                UserDefaults.standard.setValue(encodedWatchlist, forKey: Constants.watchlistKey)
            } catch {
                print("Could not set encodedWatchlist to userDefaults")
            }
        }
    }
    
    static func checkIfAlreadyOnWatchlist(tmdbID: Int) -> UIImage {
        
        var image = UIImage()
        var currentWatchlist = [WatchItem]()
        retrieveWatchlist { (watchlist) in
            currentWatchlist = watchlist
            
            let filterForCurrentMovie = currentWatchlist.filter { $0.tmdbID == tmdbID }
            
            if filterForCurrentMovie.isEmpty {
                image = IconImages.heartUnfilled.image
            } else if !filterForCurrentMovie.isEmpty {
                image = IconImages.heartFilled.image
            }
        }
        return image
    }
    
    static func updateWatchlistAfterDeletion(watchlist: [WatchItem]) {
        do {
            let encoder = JSONEncoder()
            let encodedWatchlist = try encoder.encode(watchlist)
            UserDefaults.standard.setValue(encodedWatchlist, forKey: Constants.watchlistKey)
        } catch {
            print("Could not set encodedWatchlist to userDefaults")
        }
    }
}
