

import UIKit

class landingHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerTitle: UILabel!
    
    func setTitle(title: String) {
        
        headerTitle.text = title
    }
    
}
