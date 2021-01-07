

import UIKit

class KeywordCell: UICollectionViewCell {
    
    static let reuseID = "KeywordCell"
    
    var nameLabel = UILabel()
    
    func configureCell(name: String) {
        self.nameLabel.text = name
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.backgroundColor = .systemOrange
        
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: 60),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
}
