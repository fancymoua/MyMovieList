

import UIKit

class NewDetailVC: UIViewController {
    
    // primary views
    let posterImageView = UIImageView()
    let detailsBackgroundView = UIView()
    let watchlistButton = UIButton()
    
    // goes inside detailsBackgroundView
    let titleLabel = MovieTitleLabel()
    
    let ratingStackView = UIStackView()
    let imdbLogo = UIImageView()
    let ratingLabel = UILabel()
    
    let plotLabel = MoviePlotLabel()
    
    let yearAndGenreStack = UIStackView()
    let yearView = SmallDetailBlock(icon: UIImage(systemName: "calendar")!)
    let ratedView = SmallDetailBlock(icon: UIImage(systemName: "pencil.tip.crop.circle")!)
    let directorView = LargeDetailBlock(icon: UIImage(systemName: "person.fill")!, header: "Director:")
    let actorsView = LargeDetailBlock(icon: UIImage(systemName: "person.2.square.stack")!, header: "Starring:")
    
    let watchProvidersStackView = UIStackView()
    
    let padding: CGFloat = 25
    
    var movieTitle: String?
    var imdbID: String?
    var posterImage = UIImage()
    var tmdbID: Int?
    
    var providersStackViewWidthConstraint = NSLayoutConstraint()
    var providersWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMovieDetails()
        getWatchProviders()
        
//        posterImageView.image = #imageLiteral(resourceName: "tenet")
        
        configureVC()
        addSubviews()
        configureMainViews()
        configureMovieDetailViews()
    }
    
    func addSubviews() {
        let mainViews = [posterImageView, detailsBackgroundView, watchlistButton]
        let detailViews = [titleLabel, ratingStackView, plotLabel, yearAndGenreStack, directorView, actorsView, watchProvidersStackView]
        
        for view in mainViews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        for view in detailViews {
            detailsBackgroundView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func configureMainViews() {
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
        let heartImage = UIImage(systemName: "suit.heart", withConfiguration: largeConfig)
        
        watchlistButton.setImage(heartImage, for: .normal)
        watchlistButton.backgroundColor = UIColor(white: 0.8, alpha: 0.9)
        watchlistButton.tintColor = .red
        
        posterImageView.contentMode = .scaleAspectFill
        
        detailsBackgroundView.backgroundColor = .white
        detailsBackgroundView.layer.cornerRadius = 30
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -60),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            detailsBackgroundView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            detailsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            detailsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            detailsBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            watchlistButton.bottomAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: -10),
            watchlistButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            watchlistButton.heightAnchor.constraint(equalToConstant: 40),
            watchlistButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureMovieDetailViews() {
        
        imdbLogo.image = #imageLiteral(resourceName: "imdb-square-icon")
        
        ratingLabel.font = UIFont(name: "Avenir Next", size: 18)
        ratingLabel.textColor = UIColor.black
        
        ratingStackView.addArrangedSubview(imdbLogo)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.distribution = .fillEqually
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 8
        
        yearAndGenreStack.addArrangedSubview(yearView)
        yearAndGenreStack.addArrangedSubview(ratedView)
        yearAndGenreStack.distribution = .fillEqually
        yearAndGenreStack.axis = .horizontal
        yearAndGenreStack.spacing = 5
        
        watchProvidersStackView.backgroundColor = .clear
        watchProvidersStackView.distribution = .fillEqually
        watchProvidersStackView.axis = .horizontal
        watchProvidersStackView.spacing = 10
        
//        watchProvidersStackView.backgroundColor = .systemTeal
        
        // if there is a provider, constant is increased below. Otherwise, constant is 0.
        providersStackViewWidthConstraint = NSLayoutConstraint(item: watchProvidersStackView, attribute: .width, relatedBy: .equal, toItem: .none , attribute: .notAnAttribute, multiplier: 0, constant: providersWidth)
        
        providersStackViewWidthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: ratingStackView.leadingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            ratingStackView.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 25),
            ratingStackView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            ratingStackView.widthAnchor.constraint(equalToConstant: 90),
            ratingStackView.heightAnchor.constraint(equalToConstant: 25),
            
            plotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            plotLabel.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            plotLabel.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            plotLabel.heightAnchor.constraint(equalToConstant: 100),
            
            yearAndGenreStack.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 10),
            yearAndGenreStack.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            yearAndGenreStack.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            yearAndGenreStack.heightAnchor.constraint(equalToConstant: 50),
            
            directorView.topAnchor.constraint(equalTo: yearAndGenreStack.bottomAnchor, constant: 5),
            directorView.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            directorView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            directorView.heightAnchor.constraint(equalToConstant: 70),
            
            actorsView.topAnchor.constraint(equalTo: directorView.bottomAnchor, constant: 5),
            actorsView.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            actorsView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            actorsView.heightAnchor.constraint(equalToConstant: 70),
            
            watchProvidersStackView.topAnchor.constraint(equalTo: actorsView.bottomAnchor, constant: 15),
            watchProvidersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchProvidersStackView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}

extension NewDetailVC {
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
                    let imdbRating = result.imdbRating
                    let rated = result.Rated
                    
                    DispatchQueue.main.async {
                        self.titleLabel.text = title
                        self.ratingLabel.text = imdbRating
                        self.plotLabel.text = plot
                        self.posterImageView.image = self.posterImage  // passed from previous VC
                        self.yearView.setText(text: year ?? "n/a")
                        self.ratedView.setText(text: rated ?? "n/a")
                        self.directorView.setText(text: director ?? "n/a")
                        self.actorsView.setText(text: stars ?? "n/a")
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
                    
                    if let safeFlatrate = results.flatrate {
                        for item in safeFlatrate {
                            if item.provider_id == 8 { self.addWatchProvider(.Netflix) }
                            if item.provider_id == 337 { self.addWatchProvider(.DisneyPlus) }
                            if item.provider_id == 15 { self.addWatchProvider(.Hulu) }
                            if item.provider_id == 9 { self.addWatchProvider(.AmazonPrime) }
                            if item.provider_id == 27 { self.addWatchProvider(.HBONow) }
                        }
                    }
                    
                    if let safeRent = results.rent {
                        for item in safeRent {
                            if item.provider_id == 10 { self.addWatchProvider(.AmazonVideoRent) }
                        }
                    }
                    
                    if let safeBuy = results.buy {
                        for item in safeBuy {
                            
                            if item.provider_id == 10 { self.addWatchProvider(.AmazonVideoBuy) }
                            if item.provider_id == 2 { self.addWatchProvider(.AppleITunes) }
                        }
                    }
                } catch {
                    print("Could not decode watch provider data")
                }
            }
            task.resume()
        }
    }
    
    func addWatchProvider(_ provider: WatchProviders) {
        
        var rate = String()
        var logo = UIImage()
        
        switch provider {
        case .AppleITunes:
            rate = "Buy"
            logo = #imageLiteral(resourceName: "Apple-TV-Icon")
        case .AmazonVideoRent:
            rate = "Rent"
            logo = #imageLiteral(resourceName: "Amazon-prime-icon")
        case .AmazonVideoBuy:
            rate = "Buy"
            logo = #imageLiteral(resourceName: "Amazon-prime-icon")
        case .Netflix:
            rate = "Free"
            logo = #imageLiteral(resourceName: "Netflix-icon")
        case .Hulu:
            rate = "Free"
            logo = #imageLiteral(resourceName: "Hulu-icon")
        case .HBONow:
            rate = "Free"
            logo = #imageLiteral(resourceName: "HBO-icon")
        case .DisneyPlus:
            rate = "Free"
            logo = #imageLiteral(resourceName: "Disney-Plus-icon")
        case .AmazonPrime:
            rate = "Free"
            logo = #imageLiteral(resourceName: "Amazon-prime-icon")
        }
        
        DispatchQueue.main.sync {
            let netBlock = WatchProviderBlock(image: logo, rate: rate)
            watchProvidersStackView.addArrangedSubview(netBlock)
            
            providersWidth += 60
            
            providersStackViewWidthConstraint.constant = providersWidth
          
            watchProvidersStackView.updateConstraints()
            watchProvidersStackView.layoutIfNeeded()
        }
    }
    
    func configureVC() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
