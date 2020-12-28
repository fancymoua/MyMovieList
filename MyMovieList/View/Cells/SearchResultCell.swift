

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func configureCell(title: String, posterImage: UIImage) {
        self.backgroundColor = .systemGray4
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        
        movieImageView.image = posterImage
        titleLabel.text = title
    }
}
