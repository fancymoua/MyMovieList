

import UIKit

class WatchProviderBlock: UIView {
    
    let smallView = UIView()
    let logoImageView = UIImageView()
    let rateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    init(title: String, image: UIImage, rate: String) {
        super.init(frame: .zero)
        logoImageView.image = image
        rateLabel.text = rate
        configure()
    }
    
    func configure() {
        addSubview(smallView)
        
        smallView.addSubview(logoImageView)
        smallView.addSubview(rateLabel)
        
        smallView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rateLabel.textAlignment = .center
        rateLabel.textColor = .black
        rateLabel.numberOfLines = 1
        rateLabel.font = UIFont(name: "Avenir Next", size: 11)
        
        NSLayoutConstraint.activate([
            
            smallView.widthAnchor.constraint(equalToConstant: 50),
            smallView.heightAnchor.constraint(equalToConstant: 70),
            
            logoImageView.topAnchor.constraint(equalTo: smallView.topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: smallView.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: smallView.trailingAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            rateLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            rateLabel.leadingAnchor.constraint(equalTo: smallView.leadingAnchor, constant: 5),
            rateLabel.trailingAnchor.constraint(equalTo: smallView.trailingAnchor, constant: -5),
            rateLabel.bottomAnchor.constraint(equalTo: smallView.bottomAnchor)
        ])
    }

}
