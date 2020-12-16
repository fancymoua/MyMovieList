

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    var movieTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movieTitle
    }
    
    
    

}
