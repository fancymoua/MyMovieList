

import UIKit

class SmallDetailBlock: UIView {
    
    let iconImageView = UIImageView()
    let textLabel = P2Label(numberOfLines: 3)
    
    var width = CGFloat()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(icon: UIImage) {
        super.init(frame: .zero)
        self.iconImageView.image = icon
        configure()
    }
    
    func configure() {
        backgroundColor = .systemGray5
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconImageView)
        addSubview(textLabel)
        
        iconImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setText(text: String) {
        textLabel.text = text
    }

}
