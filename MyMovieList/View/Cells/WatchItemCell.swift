

import UIKit

class WatchItemCell: UITableViewCell {
    
    static let reuseID = "WatchItemCell"

    var posterImage = UIImageView()
    var title = UILabel()
    lazy var ratingStack = horizontalStackView(subviews: [starIcon, ratingLabel], spacing: 3)
    let starIcon = UIImageView(image: IconImages.ratingStar.image)
    let ratingLabel = UILabel()
    lazy var otherInfoStackView = horizontalStackView(subviews: [yearLabel, ratedLabel], spacing: 3)
    let yearLabel = UILabel()
    let ratedLabel = UILabel()
    
    func configureCell(_ title: String, posterImage: UIImage, rating: String, year: String, rated: String) {
        self.title.text = title
        self.posterImage.image = posterImage
        self.ratingLabel.text = rating
        self.yearLabel.text = year
        self.ratedLabel.text = rated
        
        selectionStyle = .none
    }
    
    func configureConstraints() {
        addSubview(posterImage)
        addSubview(title)
        addSubview(ratingStack)
        addSubview(otherInfoStackView)
        
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        otherInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        title.textColor = .label
        title.font = UIFont(name: "Avenir Next Medium", size: 19)
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail
        title.textAlignment = .left
        
        ratingLabel.font = UIFont(name: "Avenir Next", size: 16)
        ratingLabel.textColor = .label
        
        starIcon.tintColor = .systemYellow
        
        yearLabel.font = UIFont(name: "Avenir Next Medium", size: 14)
        ratedLabel.font = UIFont(name: "Avenir Next Medium", size: 14)
        yearLabel.textColor = .systemGray
        ratedLabel.textColor = .systemGray
        
        NSLayoutConstraint.activate([
            posterImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImage.widthAnchor.constraint(equalToConstant: 48),
            posterImage.heightAnchor.constraint(equalToConstant: 70),
            posterImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            title.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 15),
//            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            title.heightAnchor.constraint(equalToConstant: 22),
            title.trailingAnchor.constraint(equalTo: ratingStack.leadingAnchor, constant: -10),
            
            ratingStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingStack.widthAnchor.constraint(equalToConstant: 50),
            ratingStack.heightAnchor.constraint(equalToConstant: 23),
            ratingStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            otherInfoStackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            otherInfoStackView.heightAnchor.constraint(equalToConstant: 20),
            otherInfoStackView.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 15),
            otherInfoStackView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
    }

}
