

import UIKit

class CastCrewVC: UIViewController {
    
    var mainCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var directorArray = [PersonModel]()
    var actorsArray = [PersonModel]()
    
    var tmdbID = Int()
    var mediaType: MediaType!

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configureSubviews()
        layoutSubviews()
        getCastCrew()
        
        mainCollectionView.register(Detail_CastCrewCellCollectionViewCell.self, forCellWithReuseIdentifier: "CastCrewCell")
        mainCollectionView.register(CastCrewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CastCrewSectionHeader.headerReuseIdentifer)
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
    }
    
    private func addSubviews() {
        let subviews = [mainCollectionView]
        
        for view in subviews {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureSubviews() {
        
        mainCollectionView.backgroundColor = .systemBackground
        mainCollectionView.isScrollEnabled = true
        
        configureCollectionViewLayout()
    }
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func getCastCrew() {
        MovieDetailsManager.getCastCrewInfo(tmdbiD: tmdbID, mediaType: mediaType) { (castArray, directorArray) in
            self.actorsArray = castArray
            self.directorArray = directorArray
            
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
            name = directorArray[indexPath.item].name ?? "no name"
        case 1:
            name = actorsArray[indexPath.item].name ?? "no name"
        default:
            name = ""
        }
        
        cell.configure(name: name)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = PersonDetailVC()
        
        var tmdbID = Int()
        
        switch indexPath.section {
        case 0:
            if let id = directorArray[indexPath.item].id {
                tmdbID = id
            } else { return }
        case 1:
            if let id = actorsArray[indexPath.item].id {
                tmdbID = id
            } else { return }
        default:
            print("Nada")
        }
        
        destVC.tmdbID = tmdbID
        
        show(destVC, sender: self)
    }
    
    func configureCollectionViewLayout() {
        
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
