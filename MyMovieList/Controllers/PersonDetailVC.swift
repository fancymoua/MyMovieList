

import UIKit

class PersonDetailVC: UIViewController {
    
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let bioLabel = UILabel()
    let creditedWorkLabel = UILabel()
    
    private let photoBaseURL = "https://image.tmdb.org/t/p/original"
    
    let cache = NSCache<NSString, UIImage>()
    
    var tmdbID = Int()
    
    let creditedCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var creditedWorkArray = [CreditedWorkResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tmdbID)
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        creditedCollectionView.register(SmallMediaCardCell.self, forCellWithReuseIdentifier: SmallMediaCardCell.reuseID)
        
        creditedCollectionView.delegate = self
        creditedCollectionView.dataSource = self

        addSubviews()
        constrainSubviews()
        
        getDetails()
        getCreditedWork()
    }
    
    private func getDetails() {
        PersonManager.getPersonDetail(tmdbID: tmdbID) { (personModel) in
            DispatchQueue.main.async {
                self.nameLabel.text = personModel.name
                self.bioLabel.text = personModel.biography
                
                if let posterPath = personModel.profile_path {
                    let posterURLString = self.photoBaseURL + "\(posterPath)"
                    
                    guard let posterURL = URL(string: posterURLString) else { return }
                    
                    if let data = try? Data(contentsOf: posterURL) {
                        let posterImage = UIImage(data: data)
                        self.avatarImageView.image = posterImage
                    }
                }
            }
        }
    }
    
    private func getCreditedWork() {
        PersonManager.getPersonCreditedWork(tmdbID: tmdbID) { (meArray) in
            self.creditedWorkArray = meArray
            DispatchQueue.main.async {
                self.creditedCollectionView.reloadData()
            }
        }
    }
    
    private func addSubviews() {
        
        let subviews = [avatarImageView, nameLabel, bioLabel, creditedCollectionView, creditedWorkLabel]
        
        for view in subviews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constrainSubviews() {
        
        nameLabel.font = UIFont(name: "Avenir Next Medium", size: 18)
        nameLabel.textAlignment = .left
        
        bioLabel.font = UIFont(name: "Avenir Next", size: 14)
        bioLabel.numberOfLines = 7
        bioLabel.adjustsFontSizeToFitWidth = true
        bioLabel.lineBreakMode = .byWordWrapping
        bioLabel.minimumScaleFactor = 0.7
        bioLabel.textAlignment = .left
        
        creditedWorkLabel.text = "Most Popular:"
        creditedWorkLabel.font = UIFont(name: "Avenir Next Medium", size: 18)
        
        creditedCollectionView.backgroundColor = .white
        configureCollectionView()
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 125),
            avatarImageView.heightAnchor.constraint(equalToConstant: 160),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 125),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bioLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            creditedWorkLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30),
            creditedWorkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            creditedWorkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            creditedWorkLabel.heightAnchor.constraint(equalToConstant: 20),
            
            creditedCollectionView.topAnchor.constraint(equalTo: creditedWorkLabel.bottomAnchor, constant: 15),
            creditedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            creditedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            creditedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
       
    }
}

extension PersonDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creditedWorkArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallMediaCardCell.reuseID, for: indexPath) as! SmallMediaCardCell
        
        var posterImage = UIImage()
        
        if let posterPath = self.creditedWorkArray[indexPath.item].poster_path {

            let endpoint = self.photoBaseURL + posterPath
            let posterImageURL = URL(string: endpoint)!

            let cacheKey = NSString(string: endpoint)

            if let image = cache.object(forKey: cacheKey) {
                posterImage = image
            } else {
                if let data = try? Data(contentsOf: posterImageURL) {
                    posterImage = UIImage(data: data) ?? #imageLiteral(resourceName: "question-mark")
                    self.cache.setObject(posterImage, forKey: cacheKey)
                }
            }
        }
        
        let title = creditedWorkArray[indexPath.item].title
        
        cell.configureCell(title: title, image: posterImage)
         
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destVC = NewDetailVC()
        
        destVC.hidesBottomBarWhenPushed = true
        
        var posterImage = UIImage()
        
        if let posterPath = self.creditedWorkArray[indexPath.item].poster_path {
            
            let endpoint = self.photoBaseURL + posterPath
            
            let cacheKey = NSString(string: endpoint)
            
            if let image = cache.object(forKey: cacheKey) {
                posterImage = image
            } else {
                posterImage =  #imageLiteral(resourceName: "question-mark")
            }
        }
        
        var mediaType: MediaType!
        
        if creditedWorkArray[indexPath.item].media_type == "movie" {
            mediaType = .Movie
        } else if creditedWorkArray[indexPath.item].media_type == "tv" {
            mediaType = .TV
        }
        
        destVC.movieTitle = creditedWorkArray[indexPath.item].title
        destVC.posterImage = posterImage
        destVC.tmdbID = creditedWorkArray[indexPath.item].id
        destVC.mediaType = mediaType
        
        show(destVC, sender: self)
    }
    
    func configureCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = view.bounds.width
        let padding: CGFloat = 5
        let minimumSpacing: CGFloat = 5
        
        let availableWidth = width - (padding * 2) - (minimumSpacing * 1)
        
        let itemWidth = availableWidth / 3
        
        flowLayout.itemSize = CGSize(width: itemWidth + 30, height: 280)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 5
        
        creditedCollectionView.collectionViewLayout = flowLayout
        
    }
    
    
}
