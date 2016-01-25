//
//  DetailedViewController.swift
//  Flicks
//
//  Created by saritha on 1/25/16.
//  Copyright © 2016 saritha. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var newimage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var Movie:NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = Movie!["title"]
        titleLabel.text = title as? String
        let overview = Movie!["overview"]
        overviewLabel.text = overview as? String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
       if let posterpath = Movie!["poster_path"] as? String
       {
        let imageUrl = NSURL(string: baseUrl + posterpath)
        newimage.setImageWithURL(imageUrl!)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
