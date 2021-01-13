
import UIKit


class LandingVC: UIViewController {
    
    let searchTextField = LandingSearchTextField()
    let keywordsCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let trendingMoviesView = UIView()
    let trendingShowsView = UIView()
    
    let trendingMoviesVC = TrendingVC()     // child view
    let trendingShowsVC = SpecialListVC()   // child view
    
    var mediaTypeSelection = Int()
    var keywordsArray = [String: String]()
    
    var userEnteredText: Bool { return !searchTextField.text!.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let subviews = [searchTextField, keywordsCollectionView, trendingMoviesView, trendingShowsView]
        
        for view in subviews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutSubviews() {
        
        configureKeywordCollectionView()
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 45),
            
            keywordsCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            keywordsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            keywordsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            keywordsCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            trendingMoviesView.topAnchor.constraint(equalTo: keywordsCollectionView.bottomAnchor, constant: 15),
            trendingMoviesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trendingMoviesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trendingMoviesView.heightAnchor.constraint(equalToConstant: 250),
            
            trendingShowsView.topAnchor.constraint(equalTo: trendingMoviesView.bottomAnchor, constant: 10),
            trendingShowsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trendingShowsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trendingShowsView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    private func addChildViews() {
        addChild(trendingMoviesVC)
        addChild(trendingShowsVC)
        
        trendingMoviesView.addSubview(trendingMoviesVC.view)
        trendingShowsView.addSubview(trendingShowsVC.view)
        
        trendingMoviesVC.didMove(toParent: self)
        trendingShowsVC.didMove(toParent: self)
        
        constrainChildViewToContainerView(childView: trendingMoviesVC.view, container: trendingMoviesView)
        constrainChildViewToContainerView(childView: trendingShowsVC.view, container: trendingShowsView)
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
            print("Please enter movie title")
            presentAlert(title: "Title missing", body: "Please enter a movie title.")
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
    

