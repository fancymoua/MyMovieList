

import UIKit

class SearchResultsVC: UIViewController {
    
    let resultsCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    enum Section {
        case main
    }
    
    var searchEndpoint = String()
    
    var searchText: String!
    var searchResultsArray = [SearchResultModel]()
    var mediaType: MediaType!
    private let photoBaseURL = Constants.API.imageURL + "w342"
    
    var datasource: UICollectionViewDiffableDataSource<Section, SearchResultModel>!
    
    let cache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsCollectionView.delegate = self
        
        resultsCollectionView.register(SmallMediaCardCell.self, forCellWithReuseIdentifier: SmallMediaCardCell.reuseID)
        
        configureVC()
        configureCollectionView()
        
        configDataSource()

        getResults(endpoint: searchEndpoint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureCollectionView() {
        
        view.addSubview(resultsCollectionView)
        resultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        resultsCollectionView.backgroundColor = .systemBackground
        
        configureCollectionViewLayout()
        
        NSLayoutConstraint.activate([
            resultsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            resultsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
    }
    
    func getResults(endpoint: String) {
        
        guard let url = URL(string: endpoint) else {
            print("Bad URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("Error making call")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Something other than 200 returned")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            if self.mediaType == .Movie {
                do {
                    let decoder = JSONDecoder()
                    let allData = try decoder.decode(MovieDataAPI.self, from: data)
                    
                    self.searchResultsArray = []
                
                    for item in allData.results {
                        if item.poster_path != nil {
                            let id = item.id
                            let title = item.title
                            let posterPath = item.poster_path
                            
                            let movie = SearchResultModel(id: id, title: title, poster_path: posterPath)

                            self.searchResultsArray.append(movie)

                            self.updateData(on: self.searchResultsArray)
                        }
                    }
                } catch {
                    print("Could not parse data")
                }
            } else if self.mediaType == .TV {
                do {
                    let decoder = JSONDecoder()
                    let allData = try decoder.decode(TVDataAPI.self, from: data)
                    
                    self.searchResultsArray = []
                
                    if let results = allData.results {
                        for item in results {
                            if item.poster_path != nil || item.id == nil {
                                guard let id = item.id else { return }
                                let title = item.name
                                let posterPath = item.poster_path
                                
                                let movie = SearchResultModel(id: id, title: title, poster_path: posterPath)
                                
                                self.searchResultsArray.append(movie)
                                
                                self.updateData(on: self.searchResultsArray)
                            }
                        }
                    }
                } catch {
                    print("Could not parse data")
                }
            }
        }
        task.resume()
    }
    
    func configDataSource() {
        datasource = UICollectionViewDiffableDataSource<Section, SearchResultModel>(collectionView: resultsCollectionView, cellProvider: { [self] (collectionView, indexPath, MovieSearchResult) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallMediaCardCell.reuseID, for: indexPath) as! SmallMediaCardCell
            
            let title = self.searchResultsArray[indexPath.item].title ?? "no title"
            var posterImage = UIImage()
            
            if let posterPath = self.searchResultsArray[indexPath.item].poster_path {
                
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
            
            cell.configureCell(title: title, image: posterImage)
            
            return cell
        })
    }
    
    func updateData(on array: [SearchResultModel]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchResultModel>()
        
        snapshot.appendSections([.main])
        
        snapshot.appendItems(array)
        
        DispatchQueue.main.async {
            self.datasource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension SearchResultsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destVC = NewDetailVC()
        
        destVC.hidesBottomBarWhenPushed = true
        
        var posterImage = UIImage()
        
        if let posterPath = self.searchResultsArray[indexPath.item].poster_path {
            
            let endpoint = self.photoBaseURL + posterPath
            
            let cacheKey = NSString(string: endpoint)
            
            if let image = cache.object(forKey: cacheKey) {
                posterImage = image
            } else {
                posterImage = #imageLiteral(resourceName: "question-mark")
            }
        }
        
        destVC.posterImage = posterImage
        destVC.tmdbID = searchResultsArray[indexPath.item].id
        destVC.mediaType = mediaType
        
        show(destVC, sender: self)
    }
}

extension SearchResultsVC {
    private func configureVC() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionViewLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = view.bounds.width
        let padding: CGFloat = 5
        let minimumSpacing: CGFloat = 5
        
        let availableWidth = width - (padding * 2) - (minimumSpacing * 1)
        
        let itemWidth = availableWidth / 3
        
        flowLayout.itemSize = CGSize(width: itemWidth + 40, height: 280)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 5
        
        resultsCollectionView.collectionViewLayout = flowLayout
        
    }
}
