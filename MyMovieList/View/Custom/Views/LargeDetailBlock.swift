

import UIKit

class LargeDetailBlock: UIView {

    let iconImageView = UIImageView()
    let headerLabel = UILabel()
    let detailLabel = P2Label(numberOfLines: 3, alignment: .left)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(icon: UIImage, header: String) {
        super.init(frame: .zero)
        self.iconImageView.image = icon
        self.headerLabel.text = header
        configure()
    }
    
    private func configure() {
        
        addSubview(iconImageView)
        addSubview(headerLabel)
        addSubview(detailLabel)
        
        backgroundColor = .systemGray5
        
        iconImageView.tintColor = .label
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 15)
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            headerLabel.widthAnchor.constraint(equalToConstant: 70),
            headerLabel.heightAnchor.constraint(equalToConstant: 25),
            
            detailLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            detailLabel.leadingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 15),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
        ])
    }
    
    func setText(text: String) {
        detailLabel.text = text
    }

}
