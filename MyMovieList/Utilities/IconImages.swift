

import UIKit

let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)

enum IconImages {
    case heartUnfilled
    case heartFilled
    
    var image: UIImage {
        switch self {
        case .heartUnfilled:
            return UIImage(systemName: "suit.heart", withConfiguration: largeConfig)!
        case .heartFilled:
            return UIImage(systemName: "suit.heart.fill", withConfiguration: largeConfig)!
        }
    }
}
