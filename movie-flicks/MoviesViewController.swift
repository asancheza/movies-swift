//
//  MoviesViewController.swift
//  movie-flicks
//
//  Created by eMobc SL on 19/01/16.
//  Copyright © 2016 Neurowork. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    /* Movies is an array of dictionaries like in the json */
    var movies: [NSDictionary]?
    var refreshControl = UIRefreshControl()
    var endpoint: String!
    //var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(refreshControl)
        
        retrieveData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func retrieveData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        /* Get the movies data from imdb */
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            /* Reload data when we get the results from imdb */
                            if self.refreshControl.refreshing {
                                self.refreshControl.endRefreshing()
                            }
                            self.tableView.reloadData()
                        
                            self.delay(0.3,closure: {MBProgressHUD.hideHUDForView(self.view, animated: true)})
                    }
                }
                
                if error != nil {
                    self.networkError()
                }
        });
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    /* Load cell with the movie data */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell",
            forIndexPath: indexPath) as! MovieCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.orangeColor()
        cell.selectedBackgroundView = backgroundView
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        return cell
    }
    
    func refresh(sender:AnyObject) {
        self.retrieveData()
    }
    
    func networkError() {
        let alert = UIAlertView()
        alert.title = "Connection Error"
        alert.message = "Error getting movies"
        alert.addButtonWithTitle("Error!")
        alert.show()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        detailViewController.movie = movie
    }
}