

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    var imdbID: String?
    var movieTitle: String?
    var movieYear: String?
    var moviePlot: String?
    var movieDirector: String?
    var movieStars: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movieTitle
        yearLabel.text = movieYear
        plotLabel.text = moviePlot
        directorLabel.text = movieDirector
        starsLabel.text = movieStars
        
        getMovieDetails()
    }
    
    func getMovieDetails() {
        let baseURL = "https://www.omdbapi.com/?apikey=1383769a&t="
        
        var movieEndpoint = String()
        
        if let title = movieTitle {
            let noSpaceTitle = title.replacingOccurrences(of: " ", with: "+")
            movieEndpoint = baseURL + noSpaceTitle
            
            print("movieEndpoint: \(movieEndpoint)")
            
            guard let url = URL(string: movieEndpoint) else {
                print("Bad movieEndpoint")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let _ = error {
                    print("error making call to OMDB")
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Something other than 200 from OMDB")
                    return
                }
                
                guard let data = data else {
                    print("No data from OMDB")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieDetailModel.self, from: data)
                    
                    print("result is \(result)")
                    
                    let title = result.Title
                    let year = result.Year
                    let plot = result.Plot
                    let director = result.Director
                    let stars = result.Actors
                    
                    DispatchQueue.main.async {
                        self.titleLabel.text = title
                        self.yearLabel.text = year
                        self.plotLabel.text = plot
                        self.directorLabel.text = director
                        self.starsLabel.text = stars
                    }
                } catch {
                    print("Error getting movie details")
                }
            }
            
            task.resume()
        }
        
        
    }
    

}
