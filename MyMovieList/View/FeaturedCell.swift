

import UIKit

class FeaturedCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(title: String, image: UIImage) {
        titleLabel.text = title
        movieImageView.image = image
    }
    
}
