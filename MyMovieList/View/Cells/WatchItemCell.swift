

import UIKit

class WatchItemCell: UITableViewCell {
    
    static let reuseID = "WatchItemCell"

    var posterImage = UIImageView()
    var title = H3Label()
    lazy var userRatingStack = horizontalStackView(subviews: [starIcon, userRatingLabel], spacing: 3)
    let starIcon = UIImageView(image: IconImages.ratingStar.image)
    let userRatingLabel = P1Label()
    lazy var yearAndContentRatingStack = horizontalStackView(subviews: [yearLabel, ratedLabel], spacing: 3)
    let yearLabel = P2Label()
    let ratedLabel = P2Label()
    
    func setWatchItemInfo(_ title: String, posterImage: UIImage, rating: String, year: String, rated: String) {
        self.title.text = title
        self.posterImage.image = posterImage
        self.userRatingLabel.text = rating
        self.yearLabel.text = year
        self.ratedLabel.text = rated
        
        selectionStyle = .none
    }
    
    func configureCell() {
        addSubview(posterImage)
        addSubview(title)
        addSubview(userRatingStack)
        addSubview(yearAndContentRatingStack)
        
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        userRatingStack.translatesAutoresizingMaskIntoConstraints = false
        yearAndContentRatingStack.translatesAutoresizingMaskIntoConstraints = false
        
        title.textAlignment = .left
        
        starIcon.tintColor = .systemYellow
        
        yearLabel.textColor = .systemGray
        ratedLabel.textColor = .systemGray
        
        NSLayoutConstraint.activate([
            posterImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImage.widthAnchor.constraint(equalToConstant: 48),
            posterImage.heightAnchor.constraint(equalToConstant: 70),
            posterImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            title.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 15),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            title.heightAnchor.constraint(equalToConstant: 22),
            title.trailingAnchor.constraint(equalTo: userRatingStack.leadingAnchor, constant: -10),
            
            userRatingStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            userRatingStack.widthAnchor.constraint(equalToConstant: 50),
            userRatingStack.heightAnchor.constraint(equalToConstant: 23),
            userRatingStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            yearAndContentRatingStack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            yearAndContentRatingStack.heightAnchor.constraint(equalToConstant: 20),
            yearAndContentRatingStack.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 15),
            yearAndContentRatingStack.widthAnchor.constraint(equalToConstant: 170)
        ])
        
    }

}
