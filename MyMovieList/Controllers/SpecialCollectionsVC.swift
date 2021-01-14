

import UIKit

class SpecialCollectionsVC: UIViewController {
    
    let collectionTitle = UILabel()
    let viewMoreButton = UIButton()
    let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var moviesArray = [SearchResultModel]()
    var mediaType: MediaType!
    
    let cache = NSCache<NSString, UIImage>()
    private let photoBaseURL = Constants.API.imageURL + "w342"
    
    var howMany: Int = 10
    var searchEndpoint = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(FeaturedMovieCell.self, forCellWithReuseIdentifier: "FeaturedMovieCell")
        
        addSubviews()
        layoutSubviews()
        configureSubviews()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func addSubviews() {
        let subviews = [collectionView, collectionTitle, viewMoreButton]
        
        for view in subviews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func layoutSubviews() {
        
        NSLayoutConstraint.activate([
            collectionTitle.topAnchor.constraint(equalTo: view.topAnchor),
            collectionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionTitle.trailingAnchor.constraint(equalTo: viewMoreButton.leadingAnchor),
            collectionTitle.heightAnchor.constraint(equalToConstant: 20),
            
            viewMoreButton.topAnchor.constraint(equalTo: view.topAnchor),
            viewMoreButton.widthAnchor.constraint(equalToConstant: 90),
            viewMoreButton.heightAnchor.constraint(equalToConstant: 20),
            viewMoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: collectionTitle.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        configureLayout()
    }
    
    func configureSubviews() {
        collectionTitle.textColor = .black
        collectionTitle.font = UIFont(name: "Avenir Next Demi Bold", size: 16)
        
        viewMoreButton.setTitle("View More", for: .normal)
        viewMoreButton.setTitleColor(.blue, for: .normal)
        viewMoreButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 14)
        viewMoreButton.titleLabel?.textAlignment = .right
        viewMoreButton.addTarget(self, action: #selector(showMoreResults), for: .touchUpInside)
        
        collectionView.backgroundColor = .systemBackground
    }
    
    func getResults(endpoint: String, type: MediaType) {
        searchEndpoint = endpoint   // gets passed to searchResultsVC when user taps "View More" to get more results
        
        let url = URL(string: endpoint)
        
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
                        
                        let movie = SearchResultModel(id: id, title: title, poster_path: posterPath)
                        self.moviesArray.append(movie)

                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
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
                    
                    if let results = allData.results {
                        for item in results {
                            guard let id = item.id else { return }
                            let title = item.name ?? "no title"
                            let posterPath = item.poster_path
                            
                            // API returns media type as a string; have to convert to our enum
                            if item.media_type == "tv" {
                                self.mediaType = .TV
                            } else if item.media_type == "movie" {
                                self.mediaType = .Movie
                            }
                            
                            let movie = SearchResultModel(id: id, title: title, poster_path: posterPath)

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
    
    func setCollectionTitle(title: String) {
        collectionTitle.text = title
        collectionTitle.textColor = .label
        collectionTitle.backgroundColor = .systemBackground
    }
}

extension SpecialCollectionsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count - howMany  // array always has 20 results; subtract howMany to get # you want to show
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedMovieCell", for: indexPath) as! FeaturedMovieCell
        
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
        
        title = moviesArray[indexPath.item].title
        
        cell.configureCell(image: posterImage)
         
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destVC = NewDetailVC()
        
        destVC.hidesBottomBarWhenPushed = true
        
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
        
        destVC.hidesBottomBarWhenPushed = true
        destVC.posterImage = posterImage
        destVC.tmdbID = moviesArray[indexPath.item].id
        destVC.mediaType = mediaType
        
        show(destVC, sender: self)
    }
}

extension SpecialCollectionsVC {
    
    @objc func showMoreResults() {
        let destVC = SearchResultsVC()
        
        destVC.searchEndpoint = searchEndpoint
        destVC.mediaType = mediaType
        destVC.navigationItem.title = collectionTitle.text
        
        show(destVC, sender: self)
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
