

import UIKit

protocol PassMovieObject {
    func updateDetailObject(movieObject: MovieDetailModel?, TVObject: TVDetailModel?)
}

class TitlePlotVC: UIViewController {
    
    // subviews
    let titleLabel = H2Label()
    let imdbLogo = UIImageView(image: #imageLiteral(resourceName: "imdb-square-icon"))
    let userRatingLabel = P2Label()
    lazy var ratingStackView = horizontalStackView(subviews: [imdbLogo, userRatingLabel], spacing: 12)
    let plotLabel = P1Label(numberOfLines: 5, alignment: .left)
    lazy var yearAndRatedStack = horizontalStackView(subviews: [yearView, contentRatingView], spacing: 5)
    let yearView = SmallDetailBlock(icon: IconImages.movieDetailDate.image)
    let contentRatingView = SmallDetailBlock(icon: IconImages.movieDetailRated.image)
    let genreView = LargeDetailBlock(icon: IconImages.movieDetailDirector.image, header: "Genres:")
    let runtimeOrSeasonsView = LargeDetailBlock(icon: IconImages.movieDetailActors.image, header: "Runtime:")
    lazy var watchProvidersStackView = horizontalStackView(subviews: [], spacing: 10)
    
    // variables populated from previous view
    var mediaType: MediaType!
    var posterImage = UIImage()
    var tmdbID: Int?
    var posterPath: String?
    
    let padding: CGFloat = 25
    var providersWidth: CGFloat = 0
    var providersStackViewWidthConstraint = NSLayoutConstraint()
    
    var DetailDelegate: PassMovieObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        addSubviews()
        configureSubviews()
        layoutSubviews()

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
    
    private func configureSubviews() {
        
        if mediaType == .Movie {
            runtimeOrSeasonsView.headerLabel.text = "Runtime:"
        } else if mediaType == .TV {
            runtimeOrSeasonsView.headerLabel.text = "Seasons:"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openPlotView))
        
        plotLabel.isUserInteractionEnabled = true
        plotLabel.addGestureRecognizer(tapGesture)
        
//        userRatingLabel.font = UIFont(name: "Avenir Next", size: 18)
//        userRatingLabel.textColor = .label
        
        // if there is a provider, constant is increased below. Otherwise, constant is 0.
        providersStackViewWidthConstraint = NSLayoutConstraint(item: watchProvidersStackView, attribute: .width, relatedBy: .equal, toItem: .none , attribute: .notAnAttribute, multiplier: 0, constant: providersWidth)
        
        providersStackViewWidthConstraint.isActive = true
    }
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: ratingStackView.leadingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
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
        MovieDetailsManager.getMovieDetails(tmdbID: tmdbID!, mediaType: mediaType) { [self] (movie) in
            
            DetailDelegate?.updateDetailObject(movieObject: movie, TVObject: nil)
            
            DispatchQueue.main.async {
                titleLabel.text = movie.title ?? "no title"
                plotLabel.text = movie.overview ?? "no plot"
                contentRatingView.setText(text: movie.rated ?? "not rated")
                userRatingLabel.text = movie.imdbRating ?? "n/a"
                genreView.setText(text: movie.genres ?? "no genres")
                
                if let releaseDate = movie.release_date {
                    var year = String()
                    
                    DateTimeFormattingManager.formatYear(dateString: releaseDate) { (daYear) in
                        year = daYear
                    }
                    yearView.setText(text: year)
                }
                
                if let runtime = movie.runtime {
                    let tuple = DateTimeFormattingManager.minutesToHoursAndMinutes(runtime)
                    runtimeOrSeasonsView.setText(text: "\(tuple.hours) hr \(tuple.leftMinutes) mins")
                }
            }
        }
    }
        
    func setTVDetails() {
        MovieDetailsManager.getTVDetails(tmdbID: tmdbID!, mediaType: mediaType) { [self] (show)  in
            
            DetailDelegate?.updateDetailObject(movieObject: nil, TVObject: show)
            
            DispatchQueue.main.async {
                titleLabel.text = show.name
                plotLabel.text = show.overview
                yearView.setText(text: show.yearAired ?? "n/a")
                contentRatingView.setText(text: show.contentRating ?? "not rated")
                genreView.setText(text: show.genres ?? "no genres")
                userRatingLabel.text = show.imdbRating
                
                if let seasonsCount = show.seasonsCount {
                    if let episodesCount = show.episodesCount {
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
    
    @objc func openPlotView() {
        
        let destVC = ExpandedTextVC()
        
        destVC.titleLabel.text = titleLabel.text ?? "no title"
        destVC.textView.text = plotLabel.text ?? "no plot"
        
        show(destVC, sender: self)
    }
}

