

import UIKit

let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)

enum IconImages {
    case heartUnfilled
    case heartFilled
    case movieDetailDate
    case movieDetailRated
    case movieDetailDirector
    case movieDetailActors
    case ratingStar
    case searchGlass
    case watchlist
    case houseFilled
    
    var image: UIImage {
        switch self {
        case .heartUnfilled:
            return UIImage(systemName: "suit.heart", withConfiguration: largeConfig)!
        case .heartFilled:
            return UIImage(systemName: "suit.heart.fill", withConfiguration: largeConfig)!
        case .movieDetailDate:
            return UIImage(systemName: "calendar")!
        case .movieDetailRated:
            return UIImage(systemName: "pencil.tip.crop.circle")!
        case .movieDetailDirector:
            return UIImage(systemName: "person.fill")!
        case .movieDetailActors:
            return UIImage(systemName: "person.2.square.stack")!
        case .ratingStar:
            return UIImage(systemName: "star.fill")!
        case .searchGlass:
            return UIImage(systemName: "magnifyingglass", withConfiguration: largeConfig)!
        case .watchlist:
            return UIImage(systemName: "list.bullet", withConfiguration: largeConfig)!
        case .houseFilled:
            return UIImage(systemName: "house.fill", withConfiguration: largeConfig)!
        }
    }
}
