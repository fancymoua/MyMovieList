

import UIKit

class H3Label: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configure() {
        font = UIFont(name: "Avenir Next Medium", size: 18)
        textColor = .label
        numberOfLines = 1
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.8
        lineBreakMode = .byTruncatingTail
    }

}
