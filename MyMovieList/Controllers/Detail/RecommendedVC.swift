

import UIKit

class RecommendedVC: UIViewController {
    
    var tmdbID = Int()
    var thisMediaType: MediaType!
    
    let specialCollectVC = SpecialCollectionsVC()
    
    private let containerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configure()
        
        addChild(specialCollectVC)
        containerView.addSubview(specialCollectVC.view)
        specialCollectVC.didMove(toParent: self)
        constrainChildViewToContainerView(childView: specialCollectVC.view)
        
        var similarEndpoint = String()
        
        if thisMediaType == .Movie {
            similarEndpoint = "https://api.themoviedb.org/3/movie/" + "\(tmdbID)" + "/recommendations?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&page=1"
            specialCollectVC.mediaType = .Movie
        } else if thisMediaType == .TV {
            similarEndpoint = "https://api.themoviedb.org/3/tv/" + "\(tmdbID)" + "/recommendations?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&page=1"
            specialCollectVC.mediaType = .TV
        }
        
        specialCollectVC.getTrendingItems(trendingURL: similarEndpoint, type: thisMediaType)
        specialCollectVC.howMany = 11
        
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
        specialCollectVC.collectionView.collectionViewLayout = layout
        
        specialCollectVC.viewMoreButton.removeFromSuperview()
    }
    
    private func configure() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func constrainChildViewToContainerView(childView: UIView) {
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: containerView.topAnchor),
            childView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            childView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}
