
import UIKit


class LandingVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    let searchButton = UIButton()
    let mediaTypePicker = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
//        createDismissKeyboardTapGesture()
        configureSearchTextField()
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
        
        destVC.searchText = searchTextField.text
        
        show(destVC, sender: self)
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

extension LandingVC {
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func configureSearchTextField() {
        searchTextField.delegate = self
        searchTextField.textColor = .label
        searchTextField.font = UIFont.preferredFont(forTextStyle: .title2)
    
        mediaTypePicker.insertSegment(withTitle: "Movie", at: 0, animated: false)
        mediaTypePicker.insertSegment(withTitle: "Show", at: 1, animated: false)
    
        mediaTypePicker.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mediaTypePicker.selectedSegmentIndex = 0
        
        searchButton.setImage(IconImages.searchGlass.image, for: .normal)
        searchButton.addTarget(self, action: #selector(pushSearchResultsVC), for: .touchUpInside)
        searchTextField.rightView = searchButton
        searchTextField.rightViewMode = .always
        searchTextField.leftView = mediaTypePicker
        searchTextField.leftViewMode = .always
    }
}
