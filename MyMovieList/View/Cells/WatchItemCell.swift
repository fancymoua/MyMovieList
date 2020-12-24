

import UIKit

class WatchItemCell: UITableViewCell {
    
    static let reuseID = "WatchItemCell"

    var posterImage = UIImageView()
    var title = UILabel()
    lazy var ratingStack = horizontalStackView(subviews: [starIcon, ratingLabel], spacing: 3)
    let starIcon = UIImageView(image: IconImages.ratingStar.image)
    let ratingLabel = UILabel()
    
    func configureCell(_ title: String, posterImage: UIImage, rating: String) {
        self.title.text = title
        self.posterImage.image = posterImage
        self.ratingLabel.text = rating
        
//        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    func configureConstraints() {
        addSubview(posterImage)
        addSubview(title)
        addSubview(ratingStack)
        
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        
        title.textColor = .black
        title.font = UIFont(name: "Avenir Next Medium", size: 19)
//        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail
        title.textAlignment = .left
//        title.minimumScaleFactor = 0.8
//        title.backgroundColor = .systemPink
        
        ratingLabel.font = UIFont(name: "Avenir Next", size: 16)
        ratingLabel.textColor = .darkGray
        
        starIcon.tintColor = .systemYellow
        
        NSLayoutConstraint.activate([
            posterImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImage.widthAnchor.constraint(equalToConstant: 48),
            posterImage.heightAnchor.constraint(equalToConstant: 70),
            posterImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            title.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 15),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.heightAnchor.constraint(equalToConstant: 70),
            title.trailingAnchor.constraint(equalTo: ratingStack.leadingAnchor, constant: -10),
            
            ratingStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingStack.widthAnchor.constraint(equalToConstant: 50),
            ratingStack.heightAnchor.constraint(equalToConstant: 23),
            ratingStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
            
        ])
        
    }

}
