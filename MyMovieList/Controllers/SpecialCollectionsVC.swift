

import UIKit

class SpecialCollectionsVC: UIViewController {
    
    let collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var moviesArray = [MovieSearchResult]()
    
    let cache = NSCache<NSString, UIImage>()
    private let photoBaseURL = "https://image.tmdb.org/t/p/original"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func getTrendingMovies(movieURL: String) {
        
        let url = URL(string: movieURL)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let _ = error {
                print("Trending - error making call")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Trending - 200 not returned")
                return
            }
            
            guard let data = data else {
                print("Trending - no data retuned")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let allData = try decoder.decode(MovieDataAPI.self, from: data)
                
                self.moviesArray = []
                
                for item in allData.results {
                    
                    let id = item.id
                    let title = item.title
                    let releaseDate = item.release_date
                    let posterPath = item.poster_path
                    
                    let movie = MovieSearchResult(id: id, title: title, release_date: releaseDate, poster_path: posterPath)
                    
                    self.moviesArray.append(movie)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } catch {
                print("Couldn't do it")
            }
        }
        
        task.resume()
        
    }
    
}

extension SpecialCollectionsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count - 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedMovieCell", for: indexPath) as! FeaturedMovieCell
        
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

extension SpecialCollectionsVC {
    func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .clear
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(FeaturedMovieCell.self, forCellWithReuseIdentifier: "FeaturedMovieCell")
        
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
