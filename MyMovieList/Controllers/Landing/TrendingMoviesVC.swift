

import UIKit

class TrendingMoviesVC: SpecialCollectionsVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionTitle(title: "Trending Movies")
        getResults(endpoint: MediaType.Movie.trendingURL, type: .Movie)
    }
    
}
