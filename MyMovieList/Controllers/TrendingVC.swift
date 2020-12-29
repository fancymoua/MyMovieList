

import UIKit

class TrendingVC: SpecialCollectionsVC {
    
    let trendingURL = "https://api.themoviedb.org/3/trending/movie/day?api_key=65db6bef59bff99c6a4504f0ce877ade"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionTitle(title: "Trending")
        getTrendingItems(trendingURL: MediaType.Movie.trendingURL, type: .Movie)
    }
    
}
