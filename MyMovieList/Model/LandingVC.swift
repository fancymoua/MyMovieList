
import UIKit


class LandingVC: UIViewController {
    
    let searchTextField = UITextField()
    let keywordsCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let trendingMoviesView = UIView()
    let popularShowsView = UIView()
    
    let searchButton = UIButton()
    let mediaTypePicker = UISegmentedControl()
    var mediaTypeSelection = Int()
    
    let trendingMoviesVC = TrendingVC()
    let trendingShowsVC = SpecialListVC()
    
    var keywordsArray = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateKeywordArray()
        
        keywordsCollectionView.delegate = self
        keywordsCollectionView.dataSource = self
        
        keywordsCollectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseID)
        
        print(keywordsArray)
        
        addSubviews()
        constrainSubviews()
        
        configureUI()
        configureSearchTextField()
        mediaTypeSelection = mediaTypePicker.selectedSegmentIndex
    }
    
    func populateKeywordArray() {
//        for item in LandingKeywords.keywords {
//            keywordsArray.append(item)
//        }
        keywordsArray = LandingKeywords.keywords
    }
    
    var userEnteredText: Bool {
        return !searchTextField.text!.isEmpty
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
        let subviews = [searchTextField, keywordsCollectionView, trendingMoviesView, popularShowsView]
        
        for view in subviews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constrainSubviews() {
        
        addChild(trendingMoviesVC)
        addChild(trendingShowsVC)
        
        trendingMoviesView.addSubview(trendingMoviesVC.view)
        popularShowsView.addSubview(trendingShowsVC.view)
        
        trendingMoviesVC.didMove(toParent: self)
        trendingShowsVC.didMove(toParent: self)
        
        keywordsCollectionView.backgroundColor = .systemBackground
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: 100, height: 35)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 5
        
        keywordsCollectionView.collectionViewLayout = flowLayout
        
        constraintAgain(childView: trendingMoviesVC.view, container: trendingMoviesView)
        constraintAgain(childView: trendingShowsVC.view, container: popularShowsView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 45),
            
            keywordsCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            keywordsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            keywordsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            keywordsCollectionView.heightAnchor.constraint(equalToConstant: 35),
            
            trendingMoviesView.topAnchor.constraint(equalTo: keywordsCollectionView.bottomAnchor, constant: 15),
            trendingMoviesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trendingMoviesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trendingMoviesView.heightAnchor.constraint(equalToConstant: 250),
            
            popularShowsView.topAnchor.constraint(equalTo: trendingMoviesView.bottomAnchor, constant: 10),
            popularShowsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            popularShowsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            popularShowsView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    func constraintAgain(childView: UIView, container: UIView) {
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: container.topAnchor),
            childView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            childView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
    }
    
    @objc func pushSearchResultsVC() {
        let destVC = SearchResultsVC()
        
        guard userEnteredText else {
            print("Please enter movie title")
            // later: show UI alert here
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
            destVC.cowEndpoint = endpoint
        }
    
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
        
        destVC.cowEndpoint = Array(keywordsArray)[indexPath.item].value
        destVC.mediaType = .Movie
        destVC.navigationItem.title = Array(keywordsArray)[indexPath.item].key
        
        show(destVC, sender: self)
    }

}

extension LandingVC {
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func configureSearchTextField() {
        searchTextField.delegate = self
        searchTextField.textColor = .label
        searchTextField.font = UIFont.preferredFont(forTextStyle: .title2)
        
        searchTextField.backgroundColor = .systemGray5
        searchTextField.borderStyle = .roundedRect
    
        mediaTypePicker.insertSegment(withTitle: "Movie", at: 0, animated: false)
        mediaTypePicker.insertSegment(withTitle: "Show", at: 1, animated: false)
        mediaTypePicker.addTarget(self, action: #selector(mediaTypeChanged(segmentedControl:)), for: .valueChanged)
    
        mediaTypePicker.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mediaTypePicker.selectedSegmentIndex = 0
        
        searchButton.setImage(IconImages.searchGlass.image, for: .normal)
        searchButton.addTarget(self, action: #selector(pushSearchResultsVC), for: .touchUpInside)
        searchTextField.rightView = searchButton
        searchTextField.rightViewMode = .always
        searchTextField.leftView = mediaTypePicker
        searchTextField.leftViewMode = .always
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
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
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
