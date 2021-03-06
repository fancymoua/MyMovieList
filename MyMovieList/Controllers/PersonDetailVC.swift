

import UIKit

class PersonDetailVC: UIViewController {
    
    let avatarImageView = UIImageView()
    let nameLabel = H3Label()
    let bioLabel = P3Label(numberOfLines: 6, alignment: .left)
    let creditedWorkLabel = H3Label()
    
    private let avatarBaseURL = Constants.API.imageURL + "w185"
    private let posterBaseURL = Constants.API.imageURL + "w342"
    
    let cache = NSCache<NSString, UIImage>()
    
    var tmdbID = Int()
    
    let creditedCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var creditedWorkArray = [CreditedWorkResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Person's id is: \(tmdbID)")
        
        creditedCollectionView.register(FeaturedMovieCell.self, forCellWithReuseIdentifier: FeaturedMovieCell.reuseID)
        
        creditedCollectionView.delegate = self
        creditedCollectionView.dataSource = self

        configureVC()
        addSubviews()
        configureSubviews()
        layoutSubviews()
        
        getPersonDetails()
        getCreditedWork()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func addSubviews() {
        
        let subviews = [avatarImageView, nameLabel, bioLabel, creditedCollectionView, creditedWorkLabel]
        
        for view in subviews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureSubviews() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openPlotView))
    
        bioLabel.isUserInteractionEnabled = true
        bioLabel.addGestureRecognizer(tapGesture)
        
        creditedWorkLabel.text = "Popular Work:"
        
        creditedCollectionView.backgroundColor = .systemBackground
        configureCollectionView()
    }
    
    private func layoutSubviews() {
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 125),
            avatarImageView.heightAnchor.constraint(equalToConstant: 160),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
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
    
    private func getPersonDetails() {
        PersonManager.getPersonDetail(tmdbID: tmdbID) { (personModel) in
            DispatchQueue.main.async {
                self.nameLabel.text = personModel.name ?? "no name"
                self.bioLabel.text = personModel.biography ?? "no bio availabile"
                
                if let posterPath = personModel.profile_path {
                    let posterURLString = self.avatarBaseURL + "\(posterPath)"
                    
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
    
    @objc func openPlotView() {
        
        let destVC = ExpandedTextVC()
        
        destVC.titleLabel.text = nameLabel.text ?? "no name"
        destVC.textView.text = bioLabel.text ?? "no bio available"
        
        show(destVC, sender: self)
    }
}

extension PersonDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creditedWorkArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedMovieCell.reuseID, for: indexPath) as! FeaturedMovieCell
        
        var posterImage = UIImage()
        
        if let posterPath = self.creditedWorkArray[indexPath.item].poster_path {

            let endpoint = self.posterBaseURL + posterPath
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
        
        cell.configureCell(image: posterImage)
         
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destVC = NewDetailVC()
        
        destVC.hidesBottomBarWhenPushed = true
        
        var posterImage = UIImage()
        
        if let posterPath = self.creditedWorkArray[indexPath.item].poster_path {
            
            let endpoint = self.posterBaseURL + posterPath
            
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
        
        destVC.posterImage = posterImage
        destVC.tmdbID = creditedWorkArray[indexPath.item].id
        destVC.mediaType = mediaType
        
        show(destVC, sender: self)
    }
    
    func configureCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = view.bounds.width
        
        let itemWidth = width / 2.5
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 60)
        flowLayout.minimumLineSpacing = 25
        flowLayout.minimumInteritemSpacing = 5
        
        creditedCollectionView.collectionViewLayout = flowLayout
    }
}

extension PersonDetailVC {
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
