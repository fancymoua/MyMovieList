
import UIKit

class FeaturedDirectorVC: SpecialCollectionsVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endpoint = "https://api.themoviedb.org/3/discover/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&region=US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_crew=525&watch_region=US"

        setCollectionTitle(title: "Featured Directors")
        getResults(endpoint: endpoint, type: .Movie)
    }
    



}
