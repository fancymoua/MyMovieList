

import UIKit

class NewDetailVC: UIViewController {
    
    // primary views
    let posterImageView = UIImageView()
    let detailsBackgroundView = UIView()
    
    // goes inside detailsBackgroundView
    let titleLabel = MovieTitleLabel()
    
    let ratingStackView = UIStackView()
    let imdbLogo = UIImageView()
    let ratingLabel = UILabel()
    
    let plotLabel = MoviePlotLabel()
    
    let yearAndGenreStack = UIStackView()
    let yearView = SmallDetailBlock(icon: #imageLiteral(resourceName: "Hulu-icon"), text: "2006")
    let genreView = SmallDetailBlock(icon: #imageLiteral(resourceName: "HBO-icon"), text: "Sci-fi/Drama")
    let directorView = LargeDetailBlock(icon: #imageLiteral(resourceName: "Netflix-icon"), header: "Director:", detail: "Denis Villeneuve")
    let actorsView = LargeDetailBlock(icon: #imageLiteral(resourceName: "Apple-TV-Icon"), header: "Starring:", detail: "Amy Adams, Jeremy Renner, Forest Whitaker")
    
    let padding: CGFloat = 25

    override func viewDidLoad() {
        super.viewDidLoad()

        setDetails()
        addSubviews()
        configureMainViews()
        configureMovieDetailViews()
    }
    
    func setDetails() {
        titleLabel.text = "Arrival"
        ratingLabel.text = "7.5"
        imdbLogo.image = #imageLiteral(resourceName: "imdb-square-icon")
//        plotLabel.text = "A linguist works with the military to communicate with alien lifeforms after twelve mysterious spacecrafts appear around the world."
        plotLabel.text = "Ryan Bingham enjoys living out of a suitcase for his job, travelling around the country firing people, but finds that lifestyle threatened by the presence of a potential love interest, and a new hire presenting a new business model."
    }
    
    func addSubviews() {
        let mainViews = [posterImageView, detailsBackgroundView]
        let detailViews = [titleLabel, ratingStackView, plotLabel, yearAndGenreStack, directorView, actorsView]
        
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
        
        posterImageView.image = #imageLiteral(resourceName: "tenet")
        posterImageView.contentMode = .scaleAspectFill
        
        detailsBackgroundView.backgroundColor = .white
        detailsBackgroundView.layer.cornerRadius = 30
        
        view.sendSubviewToBack(detailsBackgroundView)
        view.sendSubviewToBack(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -60),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            detailsBackgroundView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            detailsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            detailsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            detailsBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureMovieDetailViews() {
        
        ratingLabel.font = UIFont(name: "Avenir Next", size: 18)
        ratingLabel.textColor = UIColor.black
        
        ratingStackView.addArrangedSubview(imdbLogo)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.distribution = .fillEqually
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 8
        
        yearAndGenreStack.addArrangedSubview(yearView)
        yearAndGenreStack.addArrangedSubview(genreView)
        yearAndGenreStack.distribution = .fillEqually
        yearAndGenreStack.axis = .horizontal
        yearAndGenreStack.spacing = 0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: ratingStackView.leadingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            ratingStackView.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 25),
            ratingStackView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            ratingStackView.widthAnchor.constraint(equalToConstant: 70),
            ratingStackView.heightAnchor.constraint(equalToConstant: 25),
            
            plotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            plotLabel.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            plotLabel.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            plotLabel.heightAnchor.constraint(equalToConstant: 140),
            
            yearAndGenreStack.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 10),
            yearAndGenreStack.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            yearAndGenreStack.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            yearAndGenreStack.heightAnchor.constraint(equalToConstant: 50),
            
            directorView.topAnchor.constraint(equalTo: yearAndGenreStack.bottomAnchor, constant: 0),
            directorView.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            directorView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            directorView.heightAnchor.constraint(equalToConstant: 60),
            
            actorsView.topAnchor.constraint(equalTo: directorView.bottomAnchor, constant: 0),
            actorsView.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            actorsView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            actorsView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    

}
