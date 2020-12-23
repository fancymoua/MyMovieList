

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
    
    init(image: UIImage, rate: String) {
        super.init(frame: .zero)
        logoImageView.image = image
        rateLabel.text = rate
        configure()
    }
    
    func configure() {
        
        addSubview(logoImageView)
        addSubview(rateLabel)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageView.layer.cornerRadius = 8
        logoImageView.clipsToBounds = true

        
        rateLabel.textAlignment = .center
        rateLabel.textColor = .black
        rateLabel.numberOfLines = 1
        rateLabel.font = UIFont(name: "Avenir Next", size: 11)
        
        NSLayoutConstraint.activate([
            
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            
            rateLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            rateLabel.widthAnchor.constraint(equalToConstant: 50),
            rateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

}
