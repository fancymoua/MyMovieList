
import UIKit

class P3Label: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(numberOfLines: Int) {
        super.init(frame: .zero)
        self.numberOfLines = numberOfLines
        configure()
    }
    
    private func configure() {
        font = UIFont(name: "Avenir Next", size: 14)
        lineBreakMode = .byWordWrapping
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
    }
}
