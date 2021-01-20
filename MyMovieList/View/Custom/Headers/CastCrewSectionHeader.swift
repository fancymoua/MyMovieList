

import UIKit

class CastCrewSectionHeader: UICollectionReusableView {
    
    let sectionTitle = H2Label(alignment: .left)
    
    static let headerReuseIdentifer = "CastCrewHeader"
    
    func configureHeader(title: String) {
        
        addSubview(sectionTitle)
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        sectionTitle.text = title
        sectionTitle.font = UIFont(name: "Avenir Next Medium", size: 20)
        
        NSLayoutConstraint.activate([
            sectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            sectionTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            sectionTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionTitle.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
        
}
