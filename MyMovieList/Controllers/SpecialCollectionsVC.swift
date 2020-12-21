

import UIKit

class SpecialCollectionsVC: UIViewController {
    
    let collectionView = UICollectionView()
    
    let moviesArray = [MovieSearchResult]()
    
    let cache = NSCache<NSString, UIImage>()
    private let photoBaseURL = "https://image.tmdb.org/t/p/original"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        configureLayout()
    }
    
    func configureLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = view.bounds.width
        let padding: CGFloat = 5
        let minimumSpacing: CGFloat = 5
        
        let availableWidth = width - (padding * 2) - (minimumSpacing * 1)
        
        let itemWidth = availableWidth / 4
        
        flowLayout.itemSize = CGSize(width: itemWidth + 35, height: itemWidth + 100)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = flowLayout
    }
    
}

extension SpecialCollectionsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCell", for: indexPath) as! FeaturedCell
        
        var posterImage = UIImage()
        var title = String()
        
        if let posterPath = self.moviesArray[indexPath.item].poster_path {

            let endpoint = self.photoBaseURL + posterPath
            let posterImageURL = URL(string: endpoint)!

            let cacheKey = NSString(string: endpoint)

            if let image = cache.object(forKey: cacheKey) {
                posterImage = image
            } else {
                if let data = try? Data(contentsOf: posterImageURL) {
                    posterImage = UIImage(data: data) ?? #imageLiteral(resourceName: "question-mark")
                    self.cache.setObject(posterImage, forKey: cacheKey)
                }
            }
        }
        
        title = moviesArray[indexPath.item].title
        
        cell.configureCell(title: title, image: posterImage)
         
        return cell
    }
    
    
}
