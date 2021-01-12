

import UIKit

class RecommendedVC: SpecialCollectionsVC {
    
//    let trendingURL = "https://api.themoviedb.org/3/trending/movie/day?api_key=65db6bef59bff99c6a4504f0ce877ade"
    
    var tmdbID = Int()
    var thisMediaType: MediaType!

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = .systemPink
        
        var similarEndpoint = String()
        
        print("thisMediaType \(thisMediaType)")
        
        if thisMediaType == .Movie {
            similarEndpoint = "https://api.themoviedb.org/3/movie/" + "\(tmdbID)" + "/recommendations?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&page=1"
        } else if thisMediaType == .TV {
            similarEndpoint = "https://api.themoviedb.org/3/tv/" + "\(tmdbID)" + "/recommendations?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&page=1"
        }
        
        getTrendingItems(trendingURL: similarEndpoint, type: thisMediaType)
        
        let width = view.bounds.width
        let padding: CGFloat = 0
        let minimumSpacing: CGFloat = 0.0
        
        let availableWidth = width - (padding * 2) - (minimumSpacing * 1)
        
        let itemWidth = availableWidth / 4
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth + 10.5, height: itemWidth + 60)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = minimumSpacing
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        viewMoreButton.removeFromSuperview()
    }

}
