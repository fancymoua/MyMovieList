

import UIKit

protocol PassMovieObject {
    func updateDetailObject(movieObject: MovieDetailModel?, TVObject: TVDetailModel?)
}

class TitlePlotVC: UIViewController {
    
    let titleLabel = MovieTitleLabel()
    let imdbLogo = UIImageView(image: #imageLiteral(resourceName: "imdb-square-icon"))
    let ratingLabel = UILabel()
    lazy var ratingStackView = horizontalStackView(subviews: [imdbLogo, ratingLabel], spacing: 12)
    let plotLabel = MoviePlotLabel()
    lazy var yearAndRatedStack = horizontalStackView(subviews: [yearView, ratedView], spacing: 5)
    let yearView = SmallDetailBlock(icon: IconImages.movieDetailDate.image)
    let ratedView = SmallDetailBlock(icon: IconImages.movieDetailRated.image)
    let genreView = LargeDetailBlock(icon: IconImages.movieDetailDirector.image, header: "Genres:")
    let runtimeOrSeasonsView = LargeDetailBlock(icon: IconImages.movieDetailActors.image, header: "Runtime:")
    lazy var watchProvidersStackView = horizontalStackView(subviews: [], spacing: 10)
    
    // variables populated from previous view
    var mediaType: MediaType!
    var movieTitle: String?
    var posterImage = UIImage()
    var tmdbID: Int?
    var posterPath: String?
    
    let padding: CGFloat = 25
    var providersWidth: CGFloat = 0
    var providersStackViewWidthConstraint = NSLayoutConstraint()
    
    var disMovie = MovieDetailModel()
    var disTV = TVDetailModel()
    
    var DetailDelegate: PassMovieObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        addSubviews()
        configureMovieDetailViews()

        if mediaType == .Movie {
            setMovieDetails()
        } else if mediaType == .TV {
            setTVDetails()
        }
        
        getWatchProviders()
    }
    
    func addSubviews() {
        let detailViews = [titleLabel, ratingStackView, plotLabel, yearAndRatedStack, genreView, runtimeOrSeasonsView, watchProvidersStackView]
        
        for view in detailViews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func configureMovieDetailViews() {
        
        if mediaType == .Movie {
            runtimeOrSeasonsView.headerLabel.text = "Runtime:"
        } else if mediaType == .TV {
            runtimeOrSeasonsView.headerLabel.text = "Seasons:"
        }
        
        plotLabel.numberOfLines = 6
        
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
            yearAndRatedStack.heightAnchor.constraint(equalToConstant: 35),
            
            genreView.topAnchor.constraint(equalTo: yearAndRatedStack.bottomAnchor, constant: 5),
            genreView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            genreView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            genreView.heightAnchor.constraint(equalToConstant: 45),
            
            runtimeOrSeasonsView.topAnchor.constraint(equalTo: genreView.bottomAnchor, constant: 5),
            runtimeOrSeasonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            runtimeOrSeasonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            runtimeOrSeasonsView.heightAnchor.constraint(equalToConstant: 45),
            
            watchProvidersStackView.topAnchor.constraint(equalTo: runtimeOrSeasonsView.bottomAnchor, constant: 15),
            watchProvidersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchProvidersStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
    
    func setMovieDetails() {
        MovieDetailsManager.getMovieDetails(tmdbID: tmdbID!, mediaType: mediaType) { [self] (daMovie)  in
            disMovie = daMovie
            
            DetailDelegate?.updateDetailObject(movieObject: daMovie, TVObject: nil)
            
            DispatchQueue.main.async {
                titleLabel.text = daMovie.title
                plotLabel.text = daMovie.overview
                ratedView.setText(text: daMovie.rated ?? "not rated")
                ratingLabel.text = daMovie.imdbRating
                genreView.setText(text: daMovie.genres ?? "no genres")
                
                if let releaseDate = daMovie.release_date {
                    let year = formatYear(dateString: releaseDate)
                    yearView.setText(text: year)
                }
                
                if let runtime = daMovie.runtime {
                    let tuple = minutesToHoursAndMinutes(runtime)
                    runtimeOrSeasonsView.setText(text: "\(tuple.hours) hr \(tuple.leftMinutes) mins")
                }
            }
        }
    }
        
    func setTVDetails() {
        MovieDetailsManager.getTVDetails(tmdbID: tmdbID!, mediaType: mediaType) { [self] (daMovie)  in
            disTV = daMovie
            
            DetailDelegate?.updateDetailObject(movieObject: nil, TVObject: daMovie)
            
            DispatchQueue.main.async {
                titleLabel.text = daMovie.name
                plotLabel.text = daMovie.overview
                yearView.setText(text: daMovie.yearAired ?? "n/a")
                ratedView.setText(text: daMovie.contentRating ?? "no rating")
                genreView.setText(text: daMovie.genres ?? "no genres")
                ratingLabel.text = daMovie.imdbRating
                
                if let seasonsCount = daMovie.seasonsCount {
                    if let episodesCount = daMovie.episodesCount {
                        self.runtimeOrSeasonsView.setText(text: "\(seasonsCount) seasons / \(episodesCount) episodes")
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

