

import UIKit

class MoviePlotLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configure() {
        font = UIFont(name: "Avenir Next", size: 20)
        numberOfLines = 5
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
    }

}
