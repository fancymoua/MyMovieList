

import UIKit

class CustomKeywordButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        backgroundColor = .systemOrange
        layer.cornerRadius = 8
        titleLabel?.font = UIFont(name: "Avenir Next", size: 15)
    
    }

}
