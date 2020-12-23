

import UIKit

enum WatchProviders {
    case AppleITunes
    case AmazonVideoRent
    case AmazonVideoBuy
    case Netflix
    case Hulu
    case HBONow
    case DisneyPlus
    case AmazonPrime
    
    var logo: UIImage {
        switch self {
        case .AppleITunes:
            return #imageLiteral(resourceName: "Apple-TV-Icon")
        case .AmazonVideoRent:
            return #imageLiteral(resourceName: "Amazon-prime-icon")
        case .AmazonVideoBuy:
            return #imageLiteral(resourceName: "Amazon-prime-icon")
        case .Netflix:
            return #imageLiteral(resourceName: "Netflix-icon")
        case .Hulu:
            return #imageLiteral(resourceName: "HBO-icon")
        case .HBONow:
            return #imageLiteral(resourceName: "HBO-icon")
        case .DisneyPlus:
            return #imageLiteral(resourceName: "Disney-Plus-icon")
        case .AmazonPrime:
            return #imageLiteral(resourceName: "Amazon-prime-icon")
        }
    }
    
    var rate: String {
        switch self {
        case .AppleITunes:
            return "Buy"
        case .AmazonVideoRent:
            return "Rent"
        case .AmazonVideoBuy:
            return "Buy"
        case .Netflix:
            return "Free"
        case .Hulu:
            return "Free"
        case .HBONow:
            return "Free"
        case .DisneyPlus:
            return "Free"
        case .AmazonPrime:
            return "Free"
        }
    }
}
