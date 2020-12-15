

import UIKit

class SearchResultsVC: UIViewController {
    
    var searchText: String!
    
    private let baseURL = "https://api.themoviedb.org/3/search/movie?api_key=65db6bef59bff99c6a4504f0ce877ade&query="
    
    var searchResults = [MovieSearchResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        print("Search Text is: \(searchText)")
        getResults(for: searchText)
        print("searchResults: \(searchResults)")
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
                let results = try decoder.decode(MovieDataAPI.self, from: data)
                print("Results here \(results)")
            } catch {
                print("Something went wrong")
            }
        }
        
        task.resume()
    }
    
}

extension SearchResultsVC {
    private func configureUI() {
        
    }
}
