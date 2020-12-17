

import UIKit

class SearchResultsVC: UIViewController {
    
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    enum Section {
        case main
    }
    
    var searchText: String!
    var searchResultsArray = [MovieSearchResult]()
    
    private let baseURL = "https://api.themoviedb.org/3/search/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&query="
    private let photoBaseURL = "https://image.tmdb.org/t/p/original"
    
    var datasource: UICollectionViewDiffableDataSource<Section, MovieSearchResult>!
    
    let cache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsCollectionView.delegate = self
        
        configureCollectionView()
        configureUI()
        configDataSource()

        getResults()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getResults() {
        
        let query = searchText.replacingOccurrences(of: " ", with: "+")
        
        let endpoint = baseURL + "\(query)"
        
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
            
            do {
                let decoder = JSONDecoder()
                let allData = try decoder.decode(MovieDataAPI.self, from: data)
                
                self.searchResultsArray = []
            
                for item in allData.results {
                    let id = item.id
                    let title = item.title
                    let releaseDate = item.release_date
                    let posterPath = item.poster_path
//                    let imdbID = self.getIMDBID(id: id)
                    
                    let movie = MovieSearchResult(id: id, title: title, release_date: releaseDate, poster_path: posterPath)
                    self.searchResultsArray.append(movie)
                    
                    self.updateData(on: self.searchResultsArray)

                }
            } catch {
                print("Could not parse data")
            }
        }
        task.resume()
    }
    
    func configDataSource() {
        datasource = UICollectionViewDiffableDataSource<Section, MovieSearchResult>(collectionView: resultsCollectionView, cellProvider: { [self] (collectionView, indexPath, follower) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
            
            let title = self.searchResultsArray[indexPath.item].title
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
            
            cell.configureCell(title: title, posterImage: posterImage)
            
            return cell
        })
    }
    
    func updateData(on array: [MovieSearchResult]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieSearchResult>()
        
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
        
        let destVC = storyboard?.instantiateViewController(identifier: "MovieDetailView") as! DetailVC

        destVC.movieTitle = searchResultsArray[indexPath.item].title
//        destVC.imdbID = searchResultsArray[indexPath.item].imdbID
        
        show(destVC, sender: self)
    }
}

extension SearchResultsVC {
    private func configureUI() {
        navigationItem.title = searchText
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = view.bounds.width
        let padding: CGFloat = 5
        let minimumSpacing: CGFloat = 5
        
        let availableWidth = width - (padding * 2) - (minimumSpacing * 1)
        
        let itemWidth = availableWidth / 3
        
        flowLayout.itemSize = CGSize(width: itemWidth + 30, height: itemWidth + 90)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 5
        
        resultsCollectionView.collectionViewLayout = flowLayout
        
    }
}

extension SearchResultsVC {
    func getIMDBID(id: Int, completed: @escaping (String?) -> Void) {
            
            // get IMDB ID
            let convertURL = "https://api.themoviedb.org/3/movie/" + "\(id)" + "/external_ids?api_key=65db6bef59bff99c6a4504f0ce877ade"
            print(convertURL)
            
            guard let url = URL(string: convertURL) else {
                print("Bad convert URL")
                return
            }
        
            var cowID = String()
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let _ = error {
                    print("Cow -- error making call")
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Cow -- something other than 200")
                    return
                }
                
                guard let data = data else {
                    print("No data")
                    return
                }
                
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieIDAPI.self, from: data)
                    print("checkpoint")
                    cowID = result.imdb_id
                    completed(cowID)
                } catch {
                    print("Couldn't get IMDB ID")
                }
    
            }
        
            task.resume()

        }
}
