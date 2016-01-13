//
//  MoviesViewController.swift
//  Flicks
//
//  Created by saritha on 1/10/16.
//  Copyright © 2016 saritha. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity




class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var refreshControl:UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!
    
    var movies : [NSDictionary]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
            
           
        )
        
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            print(responseDictionary)
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            
                            self.tableView.reloadData()
                            
                    }
                }
        });
        task.resume()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let movies = movies
        {
            return movies.count

        }
        else
        {
            return 0
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let movie = movies![indexPath.row]
        let posterpath = movie["poster_path"] as! String
        let imageUrl = NSURL(string: baseUrl + posterpath)
        

        let title = movie["title"] as! String
        cell.imagenew.setImageWithURL(imageUrl!)
        cell.titlelabel.text = movie["title"] as! String
        cell.overviewlabel.text = movie["overview"] as! String
        

        return cell
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
   override func viewDidAppear(animated: Bool) {
    EZLoadingActivity.showWithDelay("Waiting", disableUI: true, seconds: 2)
    
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
