

import UIKit

class KeywordCell: UICollectionViewCell {
    
    static let reuseID = "KeywordCell"
    
    var bgView = UIView()
    var nameLabel = UILabel()
    
    func configureCell(name: String) {
        self.nameLabel.text = name
        
        addSubview(bgView)
        bgView.addSubview(nameLabel)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .systemOrange
        
        bgView.layer.cornerRadius = 6
        
//        print("nameLabel width: \(nameLabel.)")
        
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Avenir Next", size: 15)
        
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            bgView.widthAnchor.constraint(equalToConstant: 100),
//            bgView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        ])
        
    }
    
}
