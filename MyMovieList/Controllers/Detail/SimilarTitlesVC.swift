

import UIKit

class SimilarTitlesVC: UIViewController {
    
    var tmdbID = Int()
    var mediaType: MediaType!
    
    let specialCollectVC = SpecialCollectionsVC()
    
    private let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureContainerView()
        addChildView()
        populateCollectionView()
        configureCollectionViewLayout()
    }
    
    private func configureContainerView() {
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
    
    private func addChildView() {
        addChild(specialCollectVC)
        containerView.addSubview(specialCollectVC.view)
        specialCollectVC.didMove(toParent: self)
        constrainChildViewToContainerView(childView: specialCollectVC.view, container: containerView)
    }
    
    private func populateCollectionView() {
        var searchEndpoint = String()
        
        if mediaType == .Movie {
            searchEndpoint = "https://api.themoviedb.org/3/movie/" + "\(tmdbID)" + "/recommendations?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&page=1"
            specialCollectVC.mediaType = .Movie
        } else if mediaType == .TV {
            searchEndpoint = "https://api.themoviedb.org/3/tv/" + "\(tmdbID)" + "/recommendations?api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US&page=1"
            specialCollectVC.mediaType = .TV
        }
        
        specialCollectVC.getResults(endpoint: searchEndpoint, type: mediaType)
        specialCollectVC.howMany = 14
    }
    
    private func configureCollectionViewLayout() {
        let width = view.bounds.width
        
        let itemWidth = width / 3.5
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 50)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0.5
        layout.scrollDirection = .vertical
        specialCollectVC.collectionView.collectionViewLayout = layout
        
        specialCollectVC.viewMoreButton.removeFromSuperview()
    }
}
