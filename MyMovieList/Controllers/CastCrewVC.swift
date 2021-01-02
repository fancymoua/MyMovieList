

import UIKit

class CastCrewVC: UIViewController {
    
    var mainCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var testDirectorArray = [String]()
    var testActorsArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configure()
        
        mainCollectionView.register(Detail_CastCrewCellCollectionViewCell.self, forCellWithReuseIdentifier: "CastCrewCell")
        mainCollectionView.register(CastCrewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CastCrewSectionHeader.headerReuseIdentifer)
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        testDirectorArray.append("Denis Vilenueve")
        
        testActorsArray.append("Amy Adams")
        testActorsArray.append("Jeremy Renner")
        testActorsArray.append("Forrest Whitaker")
    }
    
    private func addSubviews() {
        let subviews = [mainCollectionView]
        
        for view in subviews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configure() {
        view.backgroundColor = .systemOrange
        
        mainCollectionView.backgroundColor = .systemBackground
        mainCollectionView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        configureLayout()
    }
}

extension CastCrewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = Int()
        
        if section == 0 {
            count = testDirectorArray.count
        } else if section == 1 {
            count = testActorsArray.count
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCrewCell", for: indexPath) as! Detail_CastCrewCellCollectionViewCell
        
        var name = String()
        
        if indexPath.section == 0 {
            name = testDirectorArray[indexPath.item]
        } else if indexPath.section == 1 {
            name = testActorsArray[indexPath.item]
        }
        
        cell.configure(name: name)
        
        return cell
    }
    
    func configureLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: 81, height: 81)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .vertical
        
        mainCollectionView.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CastCrewSectionHeader.headerReuseIdentifer, for: indexPath) as! CastCrewSectionHeader
        
        var sectionTitle = String()
        
        if indexPath.section == 0 {
            sectionTitle = "Director(s):"
        } else if indexPath.section == 1 {
            sectionTitle = "Actors:"
        }
        
        headerView.configureHeader(title: sectionTitle)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return CGSize(width: collectionView.frame.width, height: 60)
       }
    
    
}
