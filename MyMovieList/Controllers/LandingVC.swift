
import UIKit

class LandingVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
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
    
    func pushSearchResultsVC() {
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
    }
    
    func configureSearchTextField() {
        searchTextField.delegate = self
        searchTextField.textColor = .darkGray
        searchTextField.font = UIFont.preferredFont(forTextStyle: .title2)
    }
    
    
}
