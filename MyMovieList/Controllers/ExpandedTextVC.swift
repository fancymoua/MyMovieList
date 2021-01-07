

import UIKit

class ExpandedTextVC: UIViewController {
    
    let textView = UITextView()
    
    var text = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
    
        textView.text = text
        textView.font = UIFont(name: "Avenir Next", size: 20)
        textView.contentOffset = .zero
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    

    
}
