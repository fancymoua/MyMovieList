

import UIKit

class H1Label: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(alignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = alignment
        configure()
    }
    
    private func configure() {
        font = UIFont(name: Constants.Fonts.appFontMedium, size: 30)
        textColor = .label
        numberOfLines = 1
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.8
        lineBreakMode = .byTruncatingTail
    }

}
