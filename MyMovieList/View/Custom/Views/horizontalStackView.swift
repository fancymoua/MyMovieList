

import UIKit

class horizontalStackView: UIStackView {
    
    var spacingValue = CGFloat()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(subviews: [UIView], spacing: CGFloat) {
        super.init(frame: .zero)
        for view in subviews {
            self.addArrangedSubview(view)
        }
        spacingValue = spacing
        configure()
    }
    
    func configure() {
        distribution = .fillEqually
        axis = .horizontal
        spacing = spacingValue
    }

}
