

import UIKit

class P1Label: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(numberOfLines: Int, alignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.numberOfLines = numberOfLines
        self.textAlignment = alignment
        configure()
    }
    
    private func configure() {
        font = UIFont(name: "Avenir Next", size: 20)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
    }


}
