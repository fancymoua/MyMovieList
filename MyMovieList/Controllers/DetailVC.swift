

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchProviderStackView: UIStackView!
    
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
        print("tmdbID \(tmdbID!)")
        
//        let Netflix = WatchProviderBlock(title: "Netflix", image: #imageLiteral(resourceName: "Netflix-icon"), rate: "Free")
//        let Netflix2 = WatchProviderBlock(title: "Netflix", image: #imageLiteral(resourceName: "Hulu-icon"), rate: "Free")
//        let Netflix3 = WatchProviderBlock(title: "Netflix", image: #imageLiteral(resourceName: "HBO-icon"), rate: "Free")
//        let Netflix4 = WatchProviderBlock(title: "Netflix", image: #imageLiteral(resourceName: "Disney-Plus-icon"), rate: "Free")
//        watchProviderStackView.addArrangedSubview(Netflix)
//        watchProviderStackView.addArrangedSubview(Netflix2)
//        watchProviderStackView.addArrangedSubview(Netflix3)
//        watchProviderStackView.addArrangedSubview(Netflix4)
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
            
            guard let url = URL(string: endpoint) else {
                print("bad watch provider URL")
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

                    let providersRent = results.rent
                    let providersBuy = results.buy
                    let providersFlatrate = results.flatrate
                    
                    if let safeFlatrate = providersFlatrate {
                        for item in safeFlatrate {
                            
                            if item.provider_id == 8 {
                                print("Provider: Netflix")
                                DispatchQueue.main.sync {
                                    let netBlock = WatchProviderBlock(image: #imageLiteral(resourceName: "Netflix-icon"), rate: "Free")
                                    self.watchProviderStackView.addArrangedSubview(netBlock)
                                }
                            }
                            
                            if item.provider_id == 337 {
                                print("Provider: DisneyPlus")
                                DispatchQueue.main.sync {
                                    let netBlock = WatchProviderBlock(image: #imageLiteral(resourceName: "Disney-Plus-icon"), rate: "Free")
                                    self.watchProviderStackView.addArrangedSubview(netBlock)
                                }
                            }
                            
                            if item.provider_id == 15 {
                                print("Provider: Hulu")
                                DispatchQueue.main.sync {
                                    let netBlock = WatchProviderBlock(image: #imageLiteral(resourceName: "Hulu-icon"), rate: "Free")
                                    self.watchProviderStackView.addArrangedSubview(netBlock)
                                }
                            }
                            
                            if item.provider_id == 9 {
                                print("Provider: Amazon Prime")
                                DispatchQueue.main.sync {
                                    let netBlock = WatchProviderBlock(image: #imageLiteral(resourceName: "Amazon-prime-icon"), rate: "Free")
                                    self.watchProviderStackView.addArrangedSubview(netBlock)
                                }
                            }
                            
                            if item.provider_id == 27 {
                                print("Provider: HBO Now")
                                DispatchQueue.main.sync {
                                    let netBlock = WatchProviderBlock(image: #imageLiteral(resourceName: "HBO-icon"), rate: "Free")
                                    self.watchProviderStackView.addArrangedSubview(netBlock)
                                }
                            }
                        }
                    }
                    
                    if let safeRent = providersRent {
                        for item in safeRent {
                            
                            if item.provider_id == 10 {
                                print("Provider: Amazon Video")
                                DispatchQueue.main.sync {
                                    let netBlock = WatchProviderBlock(image: #imageLiteral(resourceName: "Amazon-prime-icon"), rate: "Rent")
                                    self.watchProviderStackView.addArrangedSubview(netBlock)
                                }
                            }
                        }
                    }
                    
                    if let safeBuy = providersBuy {
                        for item in safeBuy {
                            
                            if item.provider_id == 10 {
                                print("Provider: Amazon Video")
                                DispatchQueue.main.sync {
                                    let netBlock = WatchProviderBlock(image: #imageLiteral(resourceName: "Amazon-prime-icon"), rate: "Buy")
                                    self.watchProviderStackView.addArrangedSubview(netBlock)
                                }
                            }
                            
                            if item.provider_id == 2 {
                                print("Provider: Apple iTunes")
                                DispatchQueue.main.sync {
                                    let netBlock = WatchProviderBlock(image: #imageLiteral(resourceName: "Apple-TV-icon"), rate: "Buy")
                                    self.watchProviderStackView.addArrangedSubview(netBlock)
                                }
                            }
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
