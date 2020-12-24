

import UIKit

class FeaturedMovieCell: UICollectionViewCell {
    
    static let reuseID = "FeaturedMovieCell"
    
    var movieImageView = UIImageView()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, image: UIImage) {
        
        self.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        addSubview(movieImageView)
        addSubview(titleLabel)
        
        movieImageView.image = image
//        titleLabel.text = title
        
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieImageView.contentMode = .scaleAspectFill
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            movieImageView.heightAnchor.constraint(equalToConstant: 120),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
////            titleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 20),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
//            titleLabel.heightAnchor.constraint(equalToConstant: 50),
//            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        
        ])
    }
}
