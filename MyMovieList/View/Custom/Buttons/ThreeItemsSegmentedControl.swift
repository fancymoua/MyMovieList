

import UIKit

class ThreeItemsSegmentedControl: UISegmentedControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    private func configure() {
        insertSegment(withTitle: "Details", at: 0, animated: false)
        insertSegment(withTitle: "Cast", at: 1, animated: false)
        insertSegment(withTitle: "Similar", at: 2, animated: false)
        backgroundColor = .systemGray5
        selectedSegmentIndex = 0
    }

}
