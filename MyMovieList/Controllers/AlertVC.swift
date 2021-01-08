

import UIKit

class AlertVC: UIViewController {
    
    let bgView = UIView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let confirmButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        constrainViews()
    }
    
    init(title: String, body: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        bodyLabel.text = body
        confirmButton.setTitle("Okay", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        view.addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        let subviews = [titleLabel, bodyLabel, confirmButton]
        
        for view in subviews {
            bgView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constrainViews() {
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
        
        bgView.backgroundColor = .systemBackground
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.cornerRadius = 6
        
        confirmButton.backgroundColor = .systemOrange
        confirmButton.layer.cornerRadius = 5
        confirmButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Avenir Next Medium", size: 22)
        titleLabel.textColor = .label
        
        bodyLabel.textAlignment = .center
        bodyLabel.font = UIFont(name: "Avenir Next", size: 18)
        bodyLabel.textColor = .label
        
        titleLabel.numberOfLines = 2
        bodyLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            bgView.heightAnchor.constraint(equalToConstant: 200),
            bgView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30),
            bodyLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -20),
            bodyLabel.heightAnchor.constraint(equalToConstant: 60),
            
            confirmButton.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -15),
            confirmButton.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 35),
            confirmButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -35),
            confirmButton.heightAnchor.constraint(equalToConstant: 45),
        ])
        
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    

}
