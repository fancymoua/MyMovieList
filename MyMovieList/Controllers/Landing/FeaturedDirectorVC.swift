
import UIKit

class FeaturedDirectorVC: SpecialCollectionsVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionTitle(title: "Featured Director: Nolan")
        getResults(endpoint: Constants.API.featuredDirector, type: .Movie)
    }
    



}
