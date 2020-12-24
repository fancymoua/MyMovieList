

import UIKit

class WatchlistVC: UIViewController {
    
    let header = UILabel()
    let watchlistTableView = UITableView()
    
    var watchlistItemsArray = [WatchItem]()
    
    let cache = NSCache<NSString, UIImage>()
    
    private let photoBaseURL = "https://image.tmdb.org/t/p/original"

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configureUI()
        print(NSHomeDirectory())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getWatchlist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    fileprivate var cowTimer: Timer!
    
    func getWatchlist() {
        
        WatchlistManager.retrieveWatchlist { (watchlist) in
            self.watchlistItemsArray = watchlist
            self.watchlistTableView.reloadData()
        }
    }
    
    func addSubviews() {
        let views = [header, watchlistTableView]
        
        for view in views {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func configureUI() {
        
        header.text = "Watchlist"
        header.font = UIFont(name: "Avenir Next Regular", size: 18)
        
        watchlistTableView.register(WatchItemCell.self, forCellReuseIdentifier: WatchItemCell.reuseID)
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            header.heightAnchor.constraint(equalToConstant: 25),
            
            watchlistTableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            watchlistTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            watchlistTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            watchlistTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        
    }
}

extension WatchlistVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WatchItemCell.reuseID) as! WatchItemCell
        
        let title = watchlistItemsArray[indexPath.item].title
        let rating = watchlistItemsArray[indexPath.item].rating
        
        var posterImage = UIImage()
        
        if let posterPath = self.watchlistItemsArray[indexPath.item].posterPath {

            let endpoint = self.photoBaseURL + posterPath
            let posterImageURL = URL(string: endpoint)!

            let cacheKey = NSString(string: endpoint)

            if let image = cache.object(forKey: cacheKey) {
                posterImage = image
            } else {
                if let data = try? Data(contentsOf: posterImageURL) {
                    posterImage = UIImage(data: data) ?? #imageLiteral(resourceName: "question-mark")
                    self.cache.setObject(posterImage, forKey: cacheKey)
                }
            }
        }
        
        cell.configureCell(title, posterImage: posterImage, rating: rating ?? "n/a" )
        cell.configureConstraints()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = NewDetailVC()
        
        destVC.hidesBottomBarWhenPushed = true
        
        var posterImage = UIImage()
        
        if let posterPath = self.watchlistItemsArray[indexPath.item].posterPath {
            
            let endpoint = self.photoBaseURL + posterPath
            
            let cacheKey = NSString(string: endpoint)
            
            if let image = cache.object(forKey: cacheKey) {
                posterImage = image
            } else {
                posterImage = #imageLiteral(resourceName: "question-mark")
            }
        }
        
        destVC.movieTitle = watchlistItemsArray[indexPath.item].title
        destVC.posterImage = #imageLiteral(resourceName: "tenet")
        destVC.tmdbID = watchlistItemsArray[indexPath.item].tmdbID
        destVC.posterImage = posterImage
        
        show(destVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            let title = self.watchlistItemsArray[indexPath.item].title
            self.watchlistItemsArray.removeAll { $0.title == title }
            
            WatchlistManager.updateWatchlistAfterDeletion(watchlist: self.watchlistItemsArray)
            WatchlistManager.retrieveWatchlist { (watchlist) in
                self.watchlistItemsArray = watchlist
                self.watchlistTableView.reloadData()
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
