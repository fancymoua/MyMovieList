

import UIKit

class LandingSearchTextField: UITextField {
    
    let searchButton = UIButton()
    let mediaTypePicker = UISegmentedControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configure() {
        
        textColor = .label
        font = UIFont.preferredFont(forTextStyle: .title2)
        
        backgroundColor = .systemGray5
        borderStyle = .roundedRect
    
        mediaTypePicker.insertSegment(withTitle: "Movie", at: 0, animated: false)
        mediaTypePicker.insertSegment(withTitle: "Show", at: 1, animated: false)
    
        mediaTypePicker.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mediaTypePicker.selectedSegmentIndex = 0
        
        searchButton.setImage(IconImages.searchGlass.image, for: .normal)

        rightView = searchButton
        rightViewMode = .always
        leftView = mediaTypePicker
        leftViewMode = .always
    }

}
