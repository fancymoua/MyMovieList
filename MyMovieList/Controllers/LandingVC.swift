
import UIKit


class LandingVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    let searchButton = UIButton()
    let mediaTypePicker = UISegmentedControl()
    var mediaTypeSelection = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc func pushSearchResultsVC() {
        let destVC = storyboard?.instantiateViewController(withIdentifier: "SearchResultsView") as! SearchResultsVC
        
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
        
        destVC.searchText = searchTextField.text
        destVC.searchBaseURL = searchBaseURL
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
