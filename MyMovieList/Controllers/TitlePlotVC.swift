

import UIKit

class TitlePlotVC: UIViewController {
    
    let titleLabel = MovieTitleLabel()
    let imdbLogo = UIImageView()
    let ratingLabel = UILabel()
    lazy var ratingStackView = horizontalStackView(subviews: [imdbLogo, ratingLabel], spacing: 12)
    let plotLabel = MoviePlotLabel()
    lazy var yearAndRatedStack = horizontalStackView(subviews: [yearView, ratedView], spacing: 5)
    let yearView = SmallDetailBlock(icon: IconImages.movieDetailDate.image)
    let ratedView = SmallDetailBlock(icon: IconImages.movieDetailRated.image)
    let directorView = LargeDetailBlock(icon: IconImages.movieDetailDirector.image, header: "Director")
    let actorsView = LargeDetailBlock(icon: IconImages.movieDetailActors.image, header: "Starring")
    lazy var watchProvidersStackView = horizontalStackView(subviews: [], spacing: 10)
    
    // variables populated from previous view
    var mediaType: MediaType!
    var movieTitle: String?
    var imdbID: String?
    var posterImage = UIImage()
    var tmdbID: Int?
    var posterPath: String?
    var rating: String?
    var year: String?
    var rated: String?
    
    let padding: CGFloat = 25
    var providersWidth: CGFloat = 0
    var providersStackViewWidthConstraint = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        if mediaType == .TV {
            directorView.headerLabel.text = "Writer(s)"
        }
        
        addSubviews()
        configureMovieDetailViews()
        getMovieDetails()
        getWatchProviders()
    }
    
    func addSubviews() {
        let detailViews = [titleLabel, ratingStackView, plotLabel, yearAndRatedStack, directorView, actorsView, watchProvidersStackView]
        
        for view in detailViews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func configureMovieDetailViews() {
        
        imdbLogo.image = #imageLiteral(resourceName: "imdb-square-icon")
        
        ratingLabel.font = UIFont(name: "Avenir Next", size: 18)
        ratingLabel.textColor = .label
        
        // if there is a provider, constant is increased below. Otherwise, constant is 0.
        providersStackViewWidthConstraint = NSLayoutConstraint(item: watchProvidersStackView, attribute: .width, relatedBy: .equal, toItem: .none , attribute: .notAnAttribute, multiplier: 0, constant: providersWidth)
        
        providersStackViewWidthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: ratingStackView.leadingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            ratingStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            ratingStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ratingStackView.widthAnchor.constraint(equalToConstant: 90),
            ratingStackView.heightAnchor.constraint(equalToConstant: 20),
            
            plotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            plotLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plotLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            plotLabel.heightAnchor.constraint(equalToConstant: 100),
            
            yearAndRatedStack.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 10),
            yearAndRatedStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            yearAndRatedStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            yearAndRatedStack.heightAnchor.constraint(equalToConstant: 40),
            
            directorView.topAnchor.constraint(equalTo: yearAndRatedStack.bottomAnchor, constant: 5),
            directorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            directorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            directorView.heightAnchor.constraint(equalToConstant: 60),
            
            actorsView.topAnchor.constraint(equalTo: directorView.bottomAnchor, constant: 5),
            actorsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actorsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actorsView.heightAnchor.constraint(equalToConstant: 60),
            
            watchProvidersStackView.topAnchor.constraint(equalTo: actorsView.bottomAnchor, constant: 15),
            watchProvidersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchProvidersStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
    
    func getMovieDetails() {
        if mediaType == .Movie {
            MovieDetailsManager.getMovieDetails(tmdbID: tmdbID!, mediaType: mediaType) { [self] (daMovie)  in
                DispatchQueue.main.async {
                    self.titleLabel.text = daMovie.title
                    self.ratingLabel.text = "hold"
                    self.plotLabel.text = daMovie.overview
                    self.yearView.setText(text: daMovie.release_date ?? "n/a")
                    self.ratedView.setText(text: "hold")
                    self.actorsView.setText(text: "hold")
                    
                    if mediaType == .Movie {
                        self.directorView.setText(text: "hold")
                    } else if mediaType == .TV {
                        self.directorView.setText(text: "hold")
                    }
                }
            }
        } else if mediaType == .TV {
            MovieDetailsManager.getTVDetails(tmdbID: tmdbID!, mediaType: mediaType) { [self] (daMovie)  in
                DispatchQueue.main.async {
                    self.titleLabel.text = daMovie.name
                    self.ratingLabel.text = "hold"
                    self.plotLabel.text = daMovie.overview
                    self.yearView.setText(text: daMovie.first_air_date ?? "n/a")
                    self.ratedView.setText(text: "hold")
                    self.actorsView.setText(text: "hold")
                    
                    if mediaType == .Movie {
                        self.directorView.setText(text: "hold")
                    } else if mediaType == .TV {
                        self.directorView.setText(text: "hold")
                    }
                }
            }
        }
    }
    
    func getWatchProviders() {
        
        MovieDetailsManager.getWatchProviders(tmdbID: tmdbID, mediaType: mediaType) { [self] (providersArray) in
            
            for provider in providersArray {
                let rate = provider.rate
                let logo = provider.logo
                
                DispatchQueue.main.sync {
                    let netBlock = WatchProviderBlock(image: logo, rate: rate)
                    watchProvidersStackView.addArrangedSubview(netBlock)
                    
                    providersWidth += 60
                    
                    providersStackViewWidthConstraint.constant = providersWidth
                  
                    watchProvidersStackView.updateConstraints()
                    watchProvidersStackView.layoutIfNeeded()
                }
            }
        }
    }
}
