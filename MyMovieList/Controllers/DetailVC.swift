

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    var movieTitle: String?
    var imdbID: String?
    var posterImage = UIImage()
    var tmdbID: Int?
    
    var flatrateArray: [WatchProviderModel]?
    
    var netflix: WatchProviderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        getMovieDetails()
        getWatchProviders()
        print("tmdbID \(tmdbID)")
    }
    
    func getMovieDetails() {
        let baseURL = "https://www.omdbapi.com/?apikey=1383769a&t="
        
        var movieEndpoint = String()
        
        if let title = movieTitle {
            let query = title.replacingOccurrences(of: " ", with: "+")
            movieEndpoint = baseURL + query
            
            print("This is movieEndpoint \(movieEndpoint)")
            
            guard let url = URL(string: movieEndpoint) else {
                print("Bad movieEndpoint")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let _ = error {
                    print("error making call to OMDB")
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Something other than 200 from OMDB")
                    return
                }
                
                guard let data = data else {
                    print("No data from OMDB")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieDetailModel.self, from: data)
                    
                    let title = result.Title
                    let year = result.Year
                    let plot = result.Plot
                    let director = result.Director
                    let stars = result.Actors
                    
                    DispatchQueue.main.async {
                        self.titleLabel.text = title
                        self.yearLabel.text = year
                        self.plotLabel.text = plot
                        self.directorLabel.text = director
                        self.starsLabel.text = stars
                        self.posterImageView.image = self.posterImage
                    }
                } catch {
                    print("Error getting movie details")
                }
            }
            task.resume()
        }
    }
    
    func getWatchProviders() {
        
        if let id = tmdbID {
            let endpoint = "https://api.themoviedb.org/3/movie/" + "\(id)" + "/watch/providers?api_key=65db6bef59bff99c6a4504f0ce877ade"
            
            print("baseURLWatch \(endpoint)")
            
            guard let url = URL(string: endpoint) else {
                print("bad URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let _ = error {
                    print("Error making call to watch provider endpoint")
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Something other than 200 returned from watch provider endpoint")
                    return
                }
                
                guard let data = data else {
                    print("No data from watch provider endpoint")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let allData = try decoder.decode(WatchProviderAPI.self, from: data)
                    
                    let results = allData.results.US
                    let providersAds = results.ads
                    let providersRent = results.rent
                    let providersBuy = results.buy
                    let providersFlaterate = results.flatrate
                    
                    print("providersFlaterate: \(providersFlaterate)")
                    
                    self.flatrateArray = [WatchProviderModel]()
                    
                    for item in providersFlaterate! {
                        let name = item.provider_name
                        let id = item.provider_id
                        let logoPath = item.logo_path
                        let displayPriority = item.display_priority
                        
                        if item.provider_name == "Netflix" {
                            print("Yeah it's Netflix")
                            let newProvider = WatchProviderModel(name: name, providerID: id, displayPriority: displayPriority, logoPath: logoPath)
                            self.netflix = newProvider
                            print("this is netflix \(self.netflix)")
                        }
                    }
                } catch {
                    print("Could not decode watch provider data")
                }
            }
            
            task.resume()
            
        }
        
    }
}

extension DetailVC {
    private func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
