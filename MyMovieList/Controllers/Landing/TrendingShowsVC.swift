
import UIKit

class TrendingShowsVC: SpecialCollectionsVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionTitle(title: "Popular Shows")
        getResults(endpoint: MediaType.TV.trendingURL, type: .TV)
    }
}
