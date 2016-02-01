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
    
    @IBOutlet weak var videoView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
    
        posterView.setImageWithURL(imageUrl!)
        
        videoView.allowsInlineMediaPlayback = true
        
        videoView.loadHTMLString("<html><body><iframe src=\"http://www.youtube.com/embed/W7qWa52k-nE\" width=\"100%\" height=\"200\" frameborder=\"0\" allowfullscreen></iframe></body></html>", baseURL: NSBundle.mainBundle().bundleURL)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}