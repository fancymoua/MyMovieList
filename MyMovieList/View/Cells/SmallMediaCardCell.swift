//
//  SmallMediaCardCell.swift
//  MyMovieList
//
//  Created by Fancy on 1/4/21.
//

import UIKit

class SmallMediaCardCell: UICollectionViewCell {
    
    static let reuseID = "SmallMediaCardCell"
    
    var movieImageView = UIImageView()
    var titleLabel = UILabel()
    var characterLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, image: UIImage, character: String) {
        
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        addSubview(movieImageView)
        addSubview(titleLabel)
        addSubview(characterLabel)
        
        movieImageView.image = image
        titleLabel.text = title
//        characterLabel.text = character
        
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        characterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieImageView.contentMode = .scaleAspectFill
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont(name: "Avenir Next Medium", size: 17)
        
//        characterLabel.textAlignment = .center
//        characterLabel.numberOfLines = 1
//        characterLabel.minimumScaleFactor = 0.5
//        characterLabel.lineBreakMode = .byTruncatingTail
//        characterLabel.font = UIFont(name: "Avenir Next Italic", size: 14)
        
        NSLayoutConstraint.activate([
            
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 200),
            
//            characterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
//            characterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
//            characterLabel.heightAnchor.constraint(equalToConstant: 20),
//            characterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        
        ])
    }
}
