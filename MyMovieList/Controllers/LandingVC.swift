
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        constrainSubviews()
        
        configureUI()
        configureSearchTextField()
        mediaTypeSelection = mediaTypePicker.selectedSegmentIndex
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
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        pushSearchResultsVC()
        dismissKeyboardAndClearSearchTextField()
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
        
        keywordsCollectionView.backgroundColor = .systemPink
        
        constraintAgain(childView: trendingMoviesVC.view, container: trendingMoviesView)
        constraintAgain(childView: trendingShowsVC.view, container: popularShowsView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 45),
            
            keywordsCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            keywordsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            keywordsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            keywordsCollectionView.heightAnchor.constraint(equalToConstant: 30),
            
            trendingMoviesView.topAnchor.constraint(equalTo: keywordsCollectionView.bottomAnchor, constant: 10),
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
        let destVC = storyboard?.instantiateViewController(withIdentifier: "SearchResultsView") as! SearchResultsVC
//        let destVC = SearchResultsVC()
        
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
