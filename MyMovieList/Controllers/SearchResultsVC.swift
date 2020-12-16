

import UIKit

class SearchResultsVC: UIViewController {
    
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    var searchText: String!
    var searchResultsArray = [MovieSearchResult]()
    
    private let baseURL = "https://api.themoviedb.org/3/search/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&query="
    private let photoBaseURL = "https://image.tmdb.org/t/p/original"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
        
        configureCollectionView()
        configureUI()

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
                    
                    let movie = MovieSearchResult(id: id, title: title, release_date: releaseDate, poster_path: posterPath)
                    self.searchResultsArray.append(movie)

                    DispatchQueue.main.async {
                        self.resultsCollectionView.reloadData()
                    }
                }
            } catch {
                print("Could not parse data")
            }
        }
        task.resume()
    }
    
}

extension SearchResultsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        
        let title = self.searchResultsArray[indexPath.item].title
        var posterImage = UIImage()
        
        if let posterPath = searchResultsArray[indexPath.item].poster_path {
            let endpoint = photoBaseURL + posterPath
            let posterImageURL = URL(string: endpoint)!
            if let data = try? Data(contentsOf: posterImageURL) {
                posterImage = UIImage(data: data) ?? #imageLiteral(resourceName: "question-mark")
            }
        }
        
        cell.configureCell(title: title, posterImage: posterImage)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destVC = storyboard?.instantiateViewController(identifier: "MovieDetailView") as! DetailVC

        destVC.movieTitle = searchResultsArray[indexPath.item].title
        
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
