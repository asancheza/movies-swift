//
//  DetailViewController.swift
//  movie-flicks
//
//  Created by eMobc SL on 22/01/16.
//  Copyright © 2016 Neurowork. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var movie: NSDictionary!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        posterView.setImageWithURL(imageUrl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}