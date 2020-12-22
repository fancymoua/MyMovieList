

import UIKit

class LargeDetailBlock: UIView {

    let iconImageView = UIImageView()
    let headerLabel = UILabel()
    let detailLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(icon: UIImage, header: String, detail: String) {
        super.init(frame: .zero)
        self.iconImageView.image = icon
        self.headerLabel.text = header
        self.detailLabel.text = detail
        configure()
    }
    
    private func configure() {
        
        addSubview(iconImageView)
        addSubview(headerLabel)
        addSubview(detailLabel)
        
        backgroundColor = .systemGray6
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 16)
        
        detailLabel.font = UIFont(name: "Avenir Next", size: 16)
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.minimumScaleFactor = 0.6
        detailLabel.numberOfLines = 2
        detailLabel.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            headerLabel.widthAnchor.constraint(equalToConstant: 70),
            headerLabel.heightAnchor.constraint(equalToConstant: 25),
            
            detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailLabel.leadingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 15),
            detailLabel.widthAnchor.constraint(equalToConstant: 180),
            detailLabel.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    func setText(text: String) {
        detailLabel.text = text
    }

}
