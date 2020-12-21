

import UIKit

class FeaturedMovieCell: UICollectionViewCell {
    
    static let reuseID = "FeaturedMovieCell"
    
    var movieImageView = UIImageView(frame: .zero)
    var titleLabel = UILabel()
    
    func configureCell(title: String, image: UIImage) {
        
        self.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        addSubview(movieImageView)
        addSubview(titleLabel)
        
        movieImageView.image = image
        titleLabel.text = title
        
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieImageView.contentMode = .scaleAspectFill
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            
            movieImageView.topAnchor.constraint(equalTo: topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
             
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 90)
        
        ])
    }
}
