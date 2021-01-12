

import UIKit

class RecommendedVC: SpecialCollectionsVC {
    
    let trendingURL = "https://api.themoviedb.org/3/trending/movie/day?api_key=65db6bef59bff99c6a4504f0ce877ade"
    
    var tmdbID = Int()
//    var mediaType: MediaType

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = .systemPink
        getTrendingItems(trendingURL: MediaType.Movie.trendingURL, type: .Movie)
        
        let width = view.bounds.width
        let padding: CGFloat = 0
        let minimumSpacing: CGFloat = 0.5
        
        let availableWidth = width - (padding * 2) - (minimumSpacing * 1)
        
        let itemWidth = availableWidth / 4
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth + 10.5, height: itemWidth + 60)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        viewMoreButton.removeFromSuperview()
    }

}
