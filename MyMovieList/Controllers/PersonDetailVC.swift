

import UIKit

class PersonDetailVC: UIViewController {
    
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let bioLabel = UILabel()
    
    let creditedCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = false

        addSubviews()
        constrainSubviews()
    }
    
    private func addSubviews() {
        
        let subviews = [avatarImageView, nameLabel, bioLabel, creditedCollectionView]
        
        for view in subviews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constrainSubviews() {
        
        avatarImageView.image = #imageLiteral(resourceName: "Pedro Pascal")
        nameLabel.text = "Pedro Pascal"
        bioLabel.text = "A Chilean-born Amercian stage and screen director and actor, best known for his character in HBO's \"Game of Thrones\" and the title role in the popular Disney+ series “Star Wars: The Mandalorian”. Pedro studied acting at the Orange County High School of the Arts and New York University's Tisch School of the Arts."
        
        nameLabel.font = UIFont(name: "Avenir Next Medium", size: 18)
        nameLabel.textAlignment = .left
        
        bioLabel.font = UIFont(name: "Avenir Next", size: 14)
        bioLabel.numberOfLines = 7
        bioLabel.adjustsFontSizeToFitWidth = true
        bioLabel.lineBreakMode = .byWordWrapping
        bioLabel.minimumScaleFactor = 0.7
        bioLabel.textAlignment = .left
        
        creditedCollectionView.backgroundColor = .systemGray5
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 125),
            avatarImageView.heightAnchor.constraint(equalToConstant: 160),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 125),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bioLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            creditedCollectionView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 15),
            creditedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            creditedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            creditedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
       
    }

    

}
