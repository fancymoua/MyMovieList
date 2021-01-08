

import UIKit

class NewDetailVC: UIViewController {
    
    let titlePlotVC = TitlePlotVC()
    let castCrewVC = CastCrewVC()
    
    // primary views
    let posterImageView = UIImageView()
    let detailsBackgroundView = UIView()
    let addToWatchlistButton = UIButton()
    
    // goes inside detailsBackgroundView
    let segmentedControl = UISegmentedControl()
    var containerView = UIView()
      
    // variables populated from previous view
    var tmdbID: Int?
    var mediaType: MediaType!
    var posterImage = UIImage()
    
    var mainDetailObjectMovie = MovieDetailModel()
    var mainDetailObjectTV = TVDetailModel()
    
    var currentWatchlist = [WatchItem]()
    var onWatchlist: Bool = false
    let padding: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("tmdbID \(tmdbID!)")
        
        // passing info to child views
        titlePlotVC.mediaType = mediaType
        titlePlotVC.tmdbID = tmdbID
        titlePlotVC.DetailDelegate = self
        
        castCrewVC.tmdbID = tmdbID!
        castCrewVC.mediaType = mediaType
 
        configureVC()
        
        WatchlistManager.retrieveWatchlist { (watchlist) in self.currentWatchlist = watchlist }
     
        addSubviews()
        configureMainViews()
        
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
        let mainViews = [posterImageView, detailsBackgroundView, addToWatchlistButton ]
        let detailViews = [segmentedControl, containerView]

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
        addToWatchlistButton.setImage(WatchlistManager.checkIfAlreadyOnWatchlist(tmdbID: tmdbID!), for: .normal)
        
        if addToWatchlistButton.image(for: .normal) == IconImages.heartUnfilled.image {
            addToWatchlistButton.addTarget(self, action: #selector(watchlistButtonTapped), for: .touchUpInside)
        }
        
        posterImageView.image = self.posterImage  // passed from previous VC
        
        posterImageView.contentMode = .scaleAspectFill
        
        detailsBackgroundView.backgroundColor = .systemBackground
        detailsBackgroundView.layer.cornerRadius = 30
        
        segmentedControl.insertSegment(withTitle: "Details", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Cast", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Others", at: 2, animated: false)
        segmentedControl.backgroundColor = .systemGray5
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(switchView), for: .valueChanged)
        
        addChild(titlePlotVC)
        containerView.addSubview(titlePlotVC.view)
        titlePlotVC.didMove(toParent: self)
        constrainChildViewToContainerView(childView: titlePlotVC.view)
        
        containerView.backgroundColor = .systemPink
        
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
            addToWatchlistButton.widthAnchor.constraint(equalToConstant: 40),
            
            segmentedControl.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            segmentedControl.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(equalTo: detailsBackgroundView.bottomAnchor, constant: -10),
        ])
    }
    
    func constrainChildViewToContainerView(childView: UIView) {
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: containerView.topAnchor),
            childView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            childView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    @objc func switchView(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            addChild(titlePlotVC)
            containerView.addSubview(titlePlotVC.view)
            titlePlotVC.didMove(toParent: self)
            constrainChildViewToContainerView(childView: titlePlotVC.view)
        case 1:
            addChild(castCrewVC)
            containerView.addSubview(castCrewVC.view)
            castCrewVC.didMove(toParent: self)
            constrainChildViewToContainerView(childView: castCrewVC.view)
        default:
            return
        }
    }
    
    @objc func watchlistButtonTapped() {
        
        addToWatchlistButton.setImage(IconImages.heartFilled.image, for: .normal)
        addToWatchlistButton.removeTarget(self, action: nil, for: .touchUpInside)
        
        if mediaType == .Movie {
            if let releasedDate = mainDetailObjectMovie.release_date {
               var year = String()
                
                IDsManager.formatYear(dateString: releasedDate) { (daYear) in
                    year = daYear
                }
                
                WatchlistManager.addToWatchlist(title: mainDetailObjectMovie.title ?? "no title", tmdbID: mainDetailObjectMovie.tmdbID ?? 5, posterPath: mainDetailObjectMovie.poster_path ?? "", rating: mainDetailObjectMovie.imdbRating ?? "n/a", year: year, rated: mainDetailObjectMovie.rated ?? "n/a", imdbID: mainDetailObjectMovie.imdbID ?? "n/a", mediaType: "Movie" )
            }
        } else if mediaType == .TV {
            WatchlistManager.addToWatchlist(title: mainDetailObjectTV.name ?? "no title", tmdbID: mainDetailObjectTV.tmdbID ?? 5, posterPath: mainDetailObjectTV.poster_path ?? "", rating: mainDetailObjectTV.imdbRating ?? "n/a", year: mainDetailObjectTV.yearAired ?? "n/a", rated: mainDetailObjectTV.contentRating ?? "n/a", imdbID: mainDetailObjectMovie.imdbID ?? "n/a", mediaType: "TV" )
        }
    }
}

// conforming to PassMovieObject protocol
extension NewDetailVC: PassMovieObject {
    func updateDetailObject(movieObject: MovieDetailModel?, TVObject: TVDetailModel?) {
        if let movieObject = movieObject {
            mainDetailObjectMovie = movieObject
        }
        
        if let TVObject = TVObject {
            mainDetailObjectTV = TVObject
        }
    }
}

extension NewDetailVC {
    
    func configureVC() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
