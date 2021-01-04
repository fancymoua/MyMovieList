

import UIKit

enum WatchProviders {
    case AppleITunes
    case AmazonVideoRent
    case AmazonVideoBuy
    case Netflix
    case Hulu
    case HBONow
    case HBOMax
    case DisneyPlus
    case AmazonPrime
    
    // tmdb's provider ID
    var id: Int {
        switch self {
        case .AppleITunes:
            return 2
        case .AmazonVideoRent:
            return 10
        case .AmazonVideoBuy:
            return 10
        case .Netflix:
            return 8
        case .Hulu:
            return 15
        case .HBONow:
            return 27
        case .DisneyPlus:
            return 337
        case .AmazonPrime:
            return 9
        case .HBOMax:
            return 384
        }
    }
    
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
        case .HBOMax:
            return #imageLiteral(resourceName: "HBOMax-icon")
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
        case .HBOMax:
            return "Free"
        }
    }
}
