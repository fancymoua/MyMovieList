

import UIKit

class SpecialCollectionsVC: UIViewController {
    
    let collectionTitle = UILabel()
    let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var moviesArray = [MovieSearchResult]()
    var mediaType: MediaType!
    
    let cache = NSCache<NSString, UIImage>()
    private let photoBaseURL = "https://image.tmdb.org/t/p/original"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(FeaturedMovieCell.self, forCellWithReuseIdentifier: "FeaturedMovieCell")
        
        configureView()
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func setCollectionTitle(title: String) {
        collectionTitle.text = title
        collectionTitle.textColor = .label
        collectionTitle.backgroundColor = .systemBackground
    }
    
    func getTrendingItems(trendingURL: String, type: MediaType) {
        
        let url = URL(string: trendingURL)
        
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
            
            if type == .Movie {
                do {
                    let decoder = JSONDecoder()
                    let allData = try decoder.decode(MovieDataAPI.self, from: data)
                    
                    self.moviesArray = []
                    
                    for item in allData.results {
                        
                        let id = item.id
                        let title = item.title
                        let posterPath = item.poster_path
                        
                        if item.media_type == "tv" {
                            self.mediaType = .TV
                        } else if item.media_type == "movie" {
                            self.mediaType = .Movie
                        }
                        
                        var imdbID = String()

                        IDsManager.getIMDBID(id: id, type: .Movie) { (cowID) in
//                            imdbID = "TT"

                            let movie = MovieSearchResult(id: id, title: title, poster_path: posterPath, imdbID: imdbID)

                            self.moviesArray.append(movie)

                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                } catch {
                    print("Couldn't do it")
                }
            } else if type == .TV {
                do {
                    let decoder = JSONDecoder()
                    let allData = try decoder.decode(TVDataAPI.self, from: data)
                    
                    self.moviesArray = []
                    
                    for item in allData.results {
                        
                        let id = item.id
                        let title = item.name
                        let posterPath = item.poster_path
                        
                        if item.media_type == "tv" {
                            self.mediaType = .TV
                        } else if item.media_type == "movie" {
                            self.mediaType = .Movie
                        }
                        
                        var imdbID = String()
                        
                        IDsManager.getIMDBID(id: id, type: .TV) { (cowID) in
//                            imdbID = "TT"

                            let movie = MovieSearchResult(id: id, title: title, poster_path: posterPath, imdbID: imdbID)

                            self.moviesArray.append(movie)

                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                } catch {
                    print("couldn't do it")
                }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destVC = NewDetailVC()
        
        destVC.hidesBottomBarWhenPushed = true
        
        var posterImage = UIImage()
        
        if let posterPath = self.moviesArray[indexPath.item].poster_path {
            
            let endpoint = self.photoBaseURL + posterPath
            
            let cacheKey = NSString(string: endpoint)
            
            if let image = cache.object(forKey: cacheKey) {
                posterImage = image
            } else {
                posterImage =  #imageLiteral(resourceName: "question-mark")
            }
        }
        
        destVC.movieTitle = moviesArray[indexPath.item].title
        destVC.posterImage = posterImage
        destVC.tmdbID = moviesArray[indexPath.item].id
        destVC.posterPath = moviesArray[indexPath.item].poster_path
        destVC.imdbID = moviesArray[indexPath.item].imdbID
        destVC.mediaType = mediaType
        
        show(destVC, sender: self)
    }
}

extension SpecialCollectionsVC {
    func configureView() {
        view.addSubview(collectionView)
        view.addSubview(collectionTitle)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionTitle.translatesAutoresizingMaskIntoConstraints = false
        collectionTitle.textColor = .black
        collectionTitle.font = UIFont(name: "Avenir Next Demi Bold", size: 16)
        
        collectionView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            collectionTitle.topAnchor.constraint(equalTo: view.topAnchor),
            collectionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionTitle.heightAnchor.constraint(equalToConstant: 20),
            
            collectionView.topAnchor.constraint(equalTo: collectionTitle.bottomAnchor),
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
