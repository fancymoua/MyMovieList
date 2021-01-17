

import UIKit

class FullSizePosterVC: UIViewController {
    
    let posterImageView = UIImageView()
    let closeButton = UIButton()
    var posterImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(closeButton)
        view.addSubview(posterImageView)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.image = posterImage
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.label, for: .normal)
        closeButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            posterImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    @objc func dismissView() { self.dismiss(animated: true, completion: nil) }
}
