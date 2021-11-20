//
//  ViewController.swift
//  Flix
//
//  Created by Yuchong Lee on 11/19/21.
//

import UIKit
import AlamofireImage

// 4 steps to create table view
// 1. Constraints and Gains
// 2. Table View outlet
// 3. Declare delegate and dataSource
// 4. Add 2 functions, reload data

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // constraints and gains
    
    var movies = [[String: Any]]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Hello")
        // Have this so it will call the 2 functions below
        
        tableView.delegate = self
        tableView.dataSource = self
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String: Any]] // Download is complete here. Reload the table again.
                self.tableView.reloadData() // Refresh the data in the table
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell() // Stock cel that no one uses
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
// Might have 100 rows. That many cells take a lot of memory. If another cell is offscreen, give the recycled cell. If no recycled cells avail, make a new one.
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL+posterPath)
        cell.posterView.af.setImage(withURL: posterURL!)
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        // question mark is swift optional
        return cell
    }
}


