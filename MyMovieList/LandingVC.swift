
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
        textFieldShouldReturn(searchTextField)
    }
    

}

extension LandingVC: UITextFieldDelegate {
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        print(searchTextField.text)
        searchTextField.text = ""
        return true
    }
}

extension LandingVC {
    func configureSearchTextField() {
        searchTextField.delegate = self
        searchTextField.textColor = .darkGray
    }
}
