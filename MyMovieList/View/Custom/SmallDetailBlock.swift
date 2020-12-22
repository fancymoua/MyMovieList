

import UIKit

class SmallDetailBlock: UIView {
    
    let iconImageView = UIImageView()
    let textLabel = UILabel()
    
    var width = CGFloat()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(icon: UIImage, text: String) {
        super.init(frame: .zero)
        self.iconImageView.image = icon
        self.textLabel.text = text
        configure()
    }
    
    func configure() {
        backgroundColor = .systemGray6
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconImageView)
        addSubview(textLabel)
        
        textLabel.font = UIFont(name: "Avenir Next", size: 16)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.6
        textLabel.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
//            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            textLabel.widthAnchor.constraint(equalToConstant: 120),
            textLabel.heightAnchor.constraint(equalToConstant: 50)
            
            
        ])
    }
    
    func setText(text: String) {
        textLabel.text = text
    }

}
