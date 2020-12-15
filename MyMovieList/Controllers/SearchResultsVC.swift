

import UIKit

class SearchResultsVC: UIViewController {
    
    var searchText: String!
    
    private let baseURL = "https://api.themoviedb.org/3/search/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&query="
    
    var searchResultsArray = [MovieSearchResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        getResults(for: searchText)
        print("searchResultsArray: \(searchResultsArray)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getResults(for query: String) {
        
        let endpoint = baseURL + "\(query)"
        print("Endpoint: \(endpoint)")
        
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
            
                for item in allData.results {
                    let title = item.title
                    let releaseDate = item.release_date
                    let posterPath = item.poster_path

                    let movie = MovieSearchResult(title: title, release_date: releaseDate, poster_path: posterPath)
                    self.searchResultsArray.append(movie)
                }
                print("Search results now \(self.searchResultsArray)")
            } catch {
                print("Could not parse data")
            }
        }
        task.resume()
    }
    
}

extension SearchResultsVC {
    private func configureUI() {
        
    }
}
