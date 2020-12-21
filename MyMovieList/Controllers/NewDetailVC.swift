

import UIKit

class NewDetailVC: UIViewController {
    
    let posterImageView = UIImageView()
    let detailsBackgroundView = UIView()
    let titleLabel = UILabel()
    
    let ratingStackView = UIStackView()
    let imdbLogo = UIImageView()
    let ratingLabel = UILabel()
    
    let padding: CGFloat = 25

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configureMainViews()
        configureMovieDetailViews()
    }
    
    func addSubviews() {
        let mainViews = [posterImageView, detailsBackgroundView]
        let detailViews = [titleLabel, ratingStackView]
        
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
        
        titleLabel.text = "Tenet"
//        titleLabel.text = "The Irishman"
//        titleLabel.text = "Once Upon a Time in Hollywood"
        titleLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 22)
        titleLabel.textColor = UIColor.black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.9
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 2
        
        ratingLabel.text = "7.5"
        ratingLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        ratingLabel.textColor = UIColor.black
        
        imdbLogo.image = #imageLiteral(resourceName: "imdb-square-icon")
        
        ratingStackView.addArrangedSubview(imdbLogo)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.distribution = .fillEqually
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 5
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: ratingStackView.leadingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            ratingStackView.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 25),
            ratingStackView.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -padding),
            ratingStackView.widthAnchor.constraint(equalToConstant: 70),
            ratingStackView.heightAnchor.constraint(equalToConstant: 25),

        ])
        
    }
    

}
