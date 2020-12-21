
import UIKit

class SpecialListVC: SpecialCollectionsVC {
    
    let keywordURL = "https://api.themoviedb.org/3/keyword/65/movies?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&include_adult=false"

    override func viewDidLoad() {
        super.viewDidLoad()

        getTrendingMovies(movieURL: keywordURL)
    }
    

    

}
