

import UIKit

class TrendingVC: SpecialCollectionsVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionTitle(title: "Trending")
        getResults(endpoint: MediaType.Movie.trendingURL, type: .Movie)
    }
    
}
