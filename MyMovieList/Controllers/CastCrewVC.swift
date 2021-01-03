

import UIKit

class CastCrewVC: UIViewController {
    
    var mainCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var directorArray = [PersonModel]()
    var actorsArray = [PersonModel]()
    
    var tmdbID = Int()
    var mediaType: MediaType!
    
    let searchEndURL = "api_key=65db6bef59bff99c6a4504f0ce877ade&language=en-US"

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configure()
        
        mainCollectionView.register(Detail_CastCrewCellCollectionViewCell.self, forCellWithReuseIdentifier: "CastCrewCell")
        mainCollectionView.register(CastCrewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CastCrewSectionHeader.headerReuseIdentifer)
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        getCastCrew()
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
    
    func getCastCrew() {
        PersonManager.getCastCrewInfo(tmdbiD: tmdbID, mediaType: mediaType) { (castArray, directorArray) in
            self.directorArray = directorArray
            self.actorsArray = castArray
            
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
    }
    
}

extension CastCrewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = Int()
        
        switch section {
        case 0:
            count = directorArray.count > 4 ? 4 : directorArray.count
        case 1:
            count = actorsArray.count
        default:
            count = 0
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCrewCell", for: indexPath) as! Detail_CastCrewCellCollectionViewCell
        
        var name = String()
        
        switch indexPath.section {
        case 0:
            name = directorArray[indexPath.item].name!
        case 1:
            name = actorsArray[indexPath.item].name!
        default:
            name = ""
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
        
        switch indexPath.section {
        case 0:
            switch mediaType {
            case .Movie:
                sectionTitle = "Director(s)"
            case .TV:
                sectionTitle = "Executive Producer(s)"
            case .none:
                sectionTitle = ""
            }
        case 1:
            sectionTitle = "Starring:"
        default:
            sectionTitle = ""
        }
        
        headerView.configureHeader(title: sectionTitle)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return CGSize(width: collectionView.frame.width, height: 60)
       }
}
