

import UIKit

class MovieTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configure() {
//        text = "The Irishman"
//        text = "Once Upon a Time in Hollywood"
        font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        textColor = UIColor.black
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        numberOfLines = 2
    }
}
