

import UIKit

class TrendingVC: UIViewController {
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    var moviesArray = [MovieSearchResult]()
    let baseURL = "https://api.themoviedb.org/3/trending/movie/week?api_key=65db6bef59bff99c6a4504f0ce877ade"
    let cache = NSCache<NSString, UIImage>()
    private let photoBaseURL = "https://image.tmdb.org/t/p/original"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendingCollectionView.dataSource = self
        trendingCollectionView.delegate = self
        
        configureCollectionView()
        getTrendingMovies()
        

    }
    
    func getTrendingMovies() {
        
        let url = URL(string: baseURL)
        
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
                        self.trendingCollectionView.reloadData()
                    }
                }
            } catch {
                print("Couldn't do it")
            }
        }
        
        task.resume()
        
    }
    

}

extension TrendingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count - 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCell", for: indexPath) as! FeaturedCell
        
        var posterImage = UIImage()
        
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
        
        let title = moviesArray[indexPath.item].title
        
        cell.configureCell(title: title, image: posterImage)
         
        return cell
        
    }
    
    func configureCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = view.bounds.width
        let padding: CGFloat = 5
        let minimumSpacing: CGFloat = 5
        
        let availableWidth = width - (padding * 2) - (minimumSpacing * 1)
        
        let itemWidth = availableWidth / 4
        
        flowLayout.itemSize = CGSize(width: itemWidth + 25, height: itemWidth + 80)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .horizontal
        
        trendingCollectionView.collectionViewLayout = flowLayout
        
    }
    
    
}
