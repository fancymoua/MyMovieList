

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    var imdbID: String?
    var movieTitle: String?
    var movieYear: String?
    var moviePlot: String?
    var movieDirector: String?
    var movieStars: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movieTitle
        yearLabel.text = movieYear
        plotLabel.text = moviePlot
        directorLabel.text = movieDirector
        starsLabel.text = movieStars
    }
    
    
    

}
