

import UIKit

class SearchResultsVC: UIViewController {
    
    var searchText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        print("Search Text is: \(searchText)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
}

extension SearchResultsVC {
    private func configureUI() {
        
    }
}
