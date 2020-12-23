

import UIKit

class WatchlistVC: UIViewController {
    
    let header = UILabel()
    let watchlistTableView = UITableView()
    
    var watchlistItemsArray = [WatchItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setTestData()
        addSubviews()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setTestData() {
        let movie1 = WatchItem(title: "Arrival")
        let movie2 = WatchItem(title: "The Nightmare Before Christmas")
        let movie3 = WatchItem(title: "Home Alone 3")
        let movie4 = WatchItem(title: "Up")
        let movie5 = WatchItem(title: "Die Hard")
        
        let testArray = [movie1, movie2, movie3, movie4, movie5]
        
        for movie in testArray {
            watchlistItemsArray.append(movie)
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
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
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
        
        cell.configureCell(title)
        cell.configureConstraints()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = NewDetailVC()
        
        destVC.hidesBottomBarWhenPushed = true
        
        destVC.movieTitle = watchlistItemsArray[indexPath.item].title
        destVC.posterImage = #imageLiteral(resourceName: "tenet")
        
        show(destVC, sender: self)
    }
}
