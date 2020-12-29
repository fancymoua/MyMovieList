

import UIKit

class NewDetailVC: UIViewController {
    
    // primary views
    let posterImageView = UIImageView()
    let detailsBackgroundView = UIView()
    let addToWatchlistButton = UIButton()
    
    // goes inside detailsBackgroundView
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
    
    var currentWatchlist = [WatchItem]()
    var onWatchlist: Bool = false
    let padding: CGFloat = 25
    var providersWidth: CGFloat = 0
    var providersStackViewWidthConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if mediaType == .TV {
            directorView.headerLabel.text = "Writer(s)"
        }
        
        getMovieDetails()
        configureVC()
        
        WatchlistManager.retrieveWatchlist { (watchlist) in self.currentWatchlist = watchlist }
     
        getWatchProviders()
        addSubviews()
        configureMainViews()
        configureMovieDetailViews()
        
        addTapGestureToPosterImageView()
        
    }
    
    func addTapGestureToPosterImageView() {
        posterImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openNewImageView))
        posterImageView.addGestureRecognizer(tap)
    }
    
    @objc func openNewImageView() {
        let destVC = FullSizePosterVC()
        destVC.posterImage = posterImage
        destVC.modalPresentationStyle = .fullScreen
        destVC.modalTransitionStyle = .crossDissolve
        present(destVC, animated: true, completion: nil)
    }
    
    func addSubviews() {
        let mainViews = [posterImageView, detailsBackgroundView, addToWatchlistButton]
        let detailViews = [titleLabel, ratingStackView, plotLabel, yearAndRatedStack, directorView, actorsView, watchProvidersStackView]
        
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
        addToWatchlistButton.backgroundColor = UIColor(white: 0.8, alpha: 0.9)
        addToWatchlistButton.tintColor = .red
        addToWatchlistButton.setImage(WatchlistManager.checkIfAlreadyOnWatchlist(title: movieTitle!), for: .normal)
        
        if addToWatchlistButton.image(for: .normal) == IconImages.heartUnfilled.image {
            addToWatchlistButton.addTarget(self, action: #selector(watchlistButtonTapped), for: .touchUpInside)
        }
        
        posterImageView.contentMode = .scaleAspectFill
        
        detailsBackgroundView.backgroundColor = .systemBackground
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
            
            addToWatchlistButton.bottomAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: -10),
            addToWatchlistButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            addToWatchlistButton.heightAnchor.constraint(equalToConstant: 40),
            addToWatchlistButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureMovieDetailViews() {
        
        imdbLogo.image = #imageLiteral(resourceName: "imdb-square-icon")
        
        ratingLabel.font = UIFont(name: "Avenir Next", size: 18)
        ratingLabel.textColor = .label
        
        // if there is a provider, constant is increased below. Otherwise, constant is 0.
        providersStackViewWidthConstraint = NSLayoutConstraint(item: watchProvidersStackView, attribute: .width, relatedBy: .equal, toItem: .none , attribute: .notAnAttribute, multiplier: 0, constant: providersWidth)
        
        providersStackViewWidthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: ratingStackView.leadingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            ratingStackView.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 25),
            ratingStackView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            ratingStackView.widthAnchor.constraint(equalToConstant: 90),
            ratingStackView.heightAnchor.constraint(equalToConstant: 20),
            
            plotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            plotLabel.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            plotLabel.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            plotLabel.heightAnchor.constraint(equalToConstant: 100),
            
            yearAndRatedStack.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 10),
            yearAndRatedStack.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            yearAndRatedStack.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            yearAndRatedStack.heightAnchor.constraint(equalToConstant: 40),
            
            directorView.topAnchor.constraint(equalTo: yearAndRatedStack.bottomAnchor, constant: 5),
            directorView.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            directorView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            directorView.heightAnchor.constraint(equalToConstant: 60),
            
            actorsView.topAnchor.constraint(equalTo: directorView.bottomAnchor, constant: 5),
            actorsView.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            actorsView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            actorsView.heightAnchor.constraint(equalToConstant: 60),
            
            watchProvidersStackView.topAnchor.constraint(equalTo: actorsView.bottomAnchor, constant: 15),
            watchProvidersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchProvidersStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
    
    @objc func watchlistButtonTapped() {
        
        addToWatchlistButton.setImage(IconImages.heartFilled.image, for: .normal)
        addToWatchlistButton.removeTarget(self, action: nil, for: .touchUpInside)
        
        WatchlistManager.addToWatchlist(title: movieTitle!, tmdbID: tmdbID!, posterPath: posterPath ?? "", rating: rating ?? "n/a", year: year ?? "n/a", rated: rated ?? "n/a" )
    }
}

extension NewDetailVC {
    
    func getMovieDetails() {
        MovieDetailsManager.getMovieDetails(imdbID: imdbID) { [self] (daMovie) in
            self.rating = daMovie.imdbRating
            self.year = daMovie.Year
            self.rated = daMovie.Rated
            DispatchQueue.main.async {
                self.titleLabel.text = daMovie.Title
                self.ratingLabel.text = daMovie.imdbRating
                self.plotLabel.text = daMovie.Plot
                self.posterImageView.image = self.posterImage  // passed from previous VC
                self.yearView.setText(text: daMovie.Year ?? "n/a")
                self.ratedView.setText(text: daMovie.Rated ?? "n/a")
                self.actorsView.setText(text: daMovie.Actors ?? "n/a")
                
                if mediaType == .Movie {
                    self.directorView.setText(text: daMovie.Director ?? "n/a")
                } else if mediaType == .TV {
                    self.directorView.setText(text: daMovie.Writer ?? "n/a")
                }
            }
        }
    }
    
    func getWatchProviders() {
        
        MovieDetailsManager.getWatchProviders(tmdbID: tmdbID, mediaType: mediaType) { [self] (providersArray) in
            print("providersArray: \(providersArray)")
            
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
    
    func configureVC() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
