

import UIKit

class Detail_CastCrewCellCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "CastCrewCell"
    
    private var bgView = UIView()
    var nameLabel = P3Label(numberOfLines: 2, alignment: .center)
    
    func configure(name: String) {
        addSubview(bgView)
        addSubview(self.nameLabel)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .systemOrange
        bgView.layer.cornerRadius = 0.5 * bounds.size.height
        bgView.clipsToBounds = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        
        self.nameLabel.text = name
        
        NSLayoutConstraint.activate([
            
            bgView.widthAnchor.constraint(equalToConstant: 80),
            bgView.heightAnchor.constraint(equalToConstant: 80),
            bgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bgView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nameLabel.widthAnchor.constraint(equalToConstant: 60),
            nameLabel.heightAnchor.constraint(equalToConstant: 60),
            nameLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        ])
    }
    
}
