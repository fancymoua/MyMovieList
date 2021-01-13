
import UIKit

class SpecialListVC: SpecialCollectionsVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionTitle(title: "Popular Shows")
        getResults(endpoint: MediaType.TV.trendingURL, type: .TV)
    }
}
