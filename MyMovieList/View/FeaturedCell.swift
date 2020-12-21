

import UIKit

class FeaturedCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(title: String, image: UIImage) {
        self.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
//        titleLabel.text = title
        movieImageView.image = image
    }
    
}
