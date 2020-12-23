

import UIKit

class WatchItemCell: UITableViewCell {
    
    static let reuseID = "WatchItemCell"

    var posterImage = UIImageView()
    var title = UILabel()
    
    func configureCell(_ title: String, posterImage: UIImage) {
        self.title.text = title
        self.posterImage.image = posterImage
        
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    func configureConstraints() {
        addSubview(posterImage)
        addSubview(title)
        
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.textColor = .black
        title.font = UIFont(name: "Avenir Next Medium", size: 20)
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.9
        
        NSLayoutConstraint.activate([
            posterImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImage.widthAnchor.constraint(equalToConstant: 48),
            posterImage.heightAnchor.constraint(equalToConstant: 70),
            posterImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            title.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 15),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.heightAnchor.constraint(equalToConstant: 70),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ])
        
    }

}
