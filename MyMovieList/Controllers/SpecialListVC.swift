
import UIKit

class SpecialListVC: SpecialCollectionsVC {
    
    let keywordURL = "https://api.themoviedb.org/3/trending/tv/day?api_key=65db6bef59bff99c6a4504f0ce877ade"

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionTitle(title: "Popular Shows")
        getTrendingMovies(movieURL: MediaType.TV.trendingURL, type: .TV)
    }
}
