
import UIKit


class LandingVC: UIViewController {
    
    var contentViewSize = CGSize()
    
    let searchContainerView = UIView()
    
    let scrollView = UIScrollView(frame: .zero)
    let scrollContainerView = UIView()
    
    let searchTextField = LandingSearchTextField()
    let keywordsCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let trendingMoviesView = UIView()
    let trendingShowsView = UIView()
    let featuredDirectorView = UIView()
    
    let trendingMoviesVC = TrendingMoviesVC()     // child view
    let trendingShowsVC = TrendingShowsVC()   // child view
    let featuredDirectorVC = FeaturedDirectorVC()
    
    var mediaTypeSelection = Int()
    var keywordsArray = [String: String]()
    
    var userEnteredText: Bool { return !searchTextField.text!.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hmm = CGSize(width: self.view.frame.width, height: self.view.frame.height + 400)
        contentViewSize = hmm
        
        scrollView.frame = self.view.bounds
        scrollView.contentSize = contentViewSize
        
        scrollContainerView.frame.size = contentViewSize
        
        configureVC()
        addSubviews()
        layoutSubviews()
        addChildViews()
        addTargetsToSearchField()
        populateKeywordArray()
        
        searchTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func addSubviews() {
        view.addSubview(searchContainerView)
        view.addSubview(scrollView)
        
        view.sendSubviewToBack(scrollView)
        
        searchContainerView.addSubview(searchTextField)
        
        scrollView.addSubview(scrollContainerView)
        
        scrollContainerView.addSubview(keywordsCollectionView)
        scrollContainerView.addSubview(trendingMoviesView)
        scrollContainerView.addSubview(trendingShowsView)
        scrollContainerView.addSubview(featuredDirectorView)
        
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        keywordsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trendingMoviesView.translatesAutoresizingMaskIntoConstraints = false
        trendingShowsView.translatesAutoresizingMaskIntoConstraints = false
        featuredDirectorView.translatesAutoresizingMaskIntoConstraints = false
        
        searchContainerView.backgroundColor = .systemBackground
        searchContainerView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func layoutSubviews() {
        
        configureKeywordCollectionView()
        
        NSLayoutConstraint.activate([
            
            searchContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            searchContainerView.heightAnchor.constraint(equalToConstant: 120),
            
            searchTextField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -5),
            searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 45),
            
            keywordsCollectionView.topAnchor.constraint(equalTo: scrollContainerView.topAnchor, constant: 90),
            keywordsCollectionView.leadingAnchor.constraint(equalTo: scrollContainerView.leadingAnchor, constant: 20),
            keywordsCollectionView.trailingAnchor.constraint(equalTo: scrollContainerView.trailingAnchor, constant: -5),
            keywordsCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            trendingMoviesView.topAnchor.constraint(equalTo: keywordsCollectionView.bottomAnchor, constant: 15),
            trendingMoviesView.leadingAnchor.constraint(equalTo: scrollContainerView.leadingAnchor, constant: 20),
            trendingMoviesView.trailingAnchor.constraint(equalTo: scrollContainerView.trailingAnchor, constant: -5),
            trendingMoviesView.heightAnchor.constraint(equalToConstant: 250),
            
            trendingShowsView.topAnchor.constraint(equalTo: trendingMoviesView.bottomAnchor, constant: 10),
            trendingShowsView.leadingAnchor.constraint(equalTo: scrollContainerView.leadingAnchor, constant: 20),
            trendingShowsView.trailingAnchor.constraint(equalTo: scrollContainerView.trailingAnchor, constant: -5),
            trendingShowsView.heightAnchor.constraint(equalToConstant: 250),
            
            featuredDirectorView.topAnchor.constraint(equalTo: trendingShowsView.bottomAnchor, constant: 10),
            featuredDirectorView.leadingAnchor.constraint(equalTo: scrollContainerView.leadingAnchor, constant: 20),
            featuredDirectorView.trailingAnchor.constraint(equalTo: scrollContainerView.trailingAnchor, constant: -5),
            featuredDirectorView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    private func addChildViews() {
        addChild(trendingMoviesVC)
        addChild(trendingShowsVC)
        addChild(featuredDirectorVC)
        
        trendingMoviesView.addSubview(trendingMoviesVC.view)
        trendingShowsView.addSubview(trendingShowsVC.view)
        featuredDirectorView.addSubview(featuredDirectorVC.view)
        
        trendingMoviesVC.didMove(toParent: self)
        trendingShowsVC.didMove(toParent: self)
        featuredDirectorVC.didMove(toParent: self)
        
        constrainChildViewToContainerView(childView: trendingMoviesVC.view, container: trendingMoviesView)
        constrainChildViewToContainerView(childView: trendingShowsVC.view, container: trendingShowsView)
        constrainChildViewToContainerView(childView: featuredDirectorVC.view, container: featuredDirectorView)
    }
    
    func populateKeywordArray() {
        keywordsArray = LandingKeywords.keywords
    }
    
    func configureKeywordCollectionView() {
        keywordsCollectionView.delegate = self
        keywordsCollectionView.dataSource = self
        
        keywordsCollectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseID)
        
        keywordsCollectionView.backgroundColor = .systemBackground
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: 100, height: 40)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 5
        
        keywordsCollectionView.collectionViewLayout = flowLayout
    }
    
    func addTargetsToSearchField() {
        searchTextField.searchButton.addTarget(self, action: #selector(pushSearchResultsVC), for: .touchUpInside)
        searchTextField.mediaTypePicker.addTarget(self, action: #selector(mediaTypeChanged(segmentedControl:)), for: .valueChanged)
    }
    
    @objc func pushSearchResultsVC() {
        let destVC = SearchResultsVC()
        
        guard userEnteredText else {
            presentAlert(title: "Title missing", body: "Please enter a title to perform search.")
            return
        }
        
        var searchBaseURL = String()
        var mediaSearchType: MediaType!
        
        if mediaTypeSelection == 0 {
            searchBaseURL = MediaType.Movie.searchBaseURL
            mediaSearchType = .Movie
        } else if mediaTypeSelection == 1 {
            searchBaseURL = MediaType.TV.searchBaseURL
            mediaSearchType = .TV
        }
        
        if let userText = searchTextField.text {
            let query = userText.replacingOccurrences(of: " ", with: "+")
            let endpoint = searchBaseURL + "\(query)"
            destVC.searchEndpoint = endpoint
        }
    
        destVC.hidesBottomBarWhenPushed = true
        destVC.navigationItem.title = searchTextField.text
        destVC.mediaType = mediaSearchType
        
        show(destVC, sender: self)
    }
}

extension LandingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywordsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.reuseID, for: indexPath) as! KeywordCell
        
        let cellName = Array(keywordsArray)[indexPath.item].key
        
        cell.configureCell(name: cellName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = SearchResultsVC()
        
        destVC.hidesBottomBarWhenPushed = true
        destVC.searchEndpoint = Array(keywordsArray)[indexPath.item].value
        destVC.mediaType = .Movie
        destVC.navigationItem.title = Array(keywordsArray)[indexPath.item].key
        
        show(destVC, sender: self)
    }
}

extension LandingVC {
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func mediaTypeChanged(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mediaTypeSelection = 0
        case 1:
            mediaTypeSelection = 1
        default:
            mediaTypeSelection = 0
        }
    }
    
}

extension LandingVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushSearchResultsVC()
        dismissKeyboardAndClearSearchTextField()
        return true
    }
    
    func dismissKeyboardAndClearSearchTextField() {
        searchTextField.endEditing(true)
        searchTextField.text = ""
    }
}
    

