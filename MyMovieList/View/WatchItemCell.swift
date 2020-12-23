

import UIKit

class WatchItemCell: UITableViewCell {
    
    static let reuseID = "WatchItemCell"

    var title = UILabel()
    
    func configureCell(_ title: String) {
        self.title.text = title
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
//        backgroundColor = .systemGray4
    }
    
    func configureConstraints() {
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.textColor = .black
        title.font = UIFont(name: "Avenir Next Medium", size: 20)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
    }

}
