
import UIKit

class LandingVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDismissKeyboardTapGesture()
        configureSearchTextField()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        dismissKeyboardAndClearSearchTextField()
    }
    

}

extension LandingVC: UITextFieldDelegate {
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboardAndClearSearchTextField()
        return true
    }
}

extension LandingVC {
    func configureSearchTextField() {
        searchTextField.delegate = self
        searchTextField.textColor = .darkGray
    }
    
    func dismissKeyboardAndClearSearchTextField() {
        searchTextField.endEditing(true)
        print("\(searchTextField.text)")
        searchTextField.text = ""
    }
}
