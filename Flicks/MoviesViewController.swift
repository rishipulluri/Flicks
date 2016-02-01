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




class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
   

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switch1: UISwitch!
    
    var refreshControl:UIRefreshControl!
      var filteredData: [NSDictionary]?

    @IBOutlet weak var searchoutlet: UISearchBar!
    var movieTitle:[String] = []
    
    var movies : [NSDictionary]?
    var endpoint : String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EZLoadingActivity.showWithDelay("Waiting", disableUI: true, seconds: 2)
        

        tableView.hidden = true
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
        
         self.navigationItem.title = "MovieViewer"

        

        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredData = self.movies

                            self.tableView.reloadData()
                            self.collectionView.reloadData()

                    }
                }
        });
        task.resume()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
       // tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.addSubview(refreshControl)

    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let movies = filteredData
        {
            return filteredData!.count

        }
        else
        {
            return 0
        }
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let movie = filteredData![indexPath.row]
        if let posterpath = movie["poster_path"] as? String
        {
        let imageUrl = NSURL(string: baseUrl + posterpath)
        cell.imagenew.setImageWithURL(imageUrl!)

        }
        

        
        let title = movie["title"] as! String
        
        cell.titlelabel.text = movie["title"] as? String
        cell.overviewlabel.text = movie["overview"] as? String
        

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
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = filteredData {
            return filteredData!.count
        } else {
            
            return 0
        }
        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectioncell", forIndexPath: indexPath) as! CollectionViewCell2
        
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        
        let baseURL = "http://image.tmdb.org/t/p/w500/"
        
        if let posterPath = movie["poster_path"] as? String {
            
            let imageURL = NSURL(string: baseURL + posterPath)
            
            let imageRequest = NSURLRequest(URL: imageURL!)
            cell.imagenuevo.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil {
                    print("image was NOT cached, fade in")
                    cell.imagenuevo.alpha = 0.0
                    cell.imagenuevo.image = image
                    UIView.animateWithDuration(0.7, animations: { () -> Void in
                        cell.imagenuevo.alpha = 1.0
                    })
                } else {
                    print ("image was cached")
                    cell.imagenuevo.image = image
                }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
            })
        }
        
        
        
        print("row \(indexPath.row)")
        
        return cell
        
        
    }
    
    
    
    
    @IBAction func switchact(sender: UISwitch) {
        if switch1.on {
            tableView.hidden = true
            collectionView.hidden = false
            collectionView.addSubview(refreshControl)
        } else {
            tableView.hidden = false
            collectionView.hidden = true
            tableView.addSubview(refreshControl)
        }
    }
    
            
    
   override func viewDidAppear(animated: Bool) {
        }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            
            let title = movie["title"] as! String
            let overview = movie["overview"] as! String

            
            return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil || overview.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        tableView.reloadData()
        collectionView.reloadData()
        
    }
    
   
   
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
        
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchoutlet.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
        filteredData = movies
        searchBar.text = nil
        tableView.reloadData()
        collectionView.reloadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if  tableView.hidden == false
        {
            let cell = sender as! UITableViewCell
          let  indexpath = tableView.indexPathForCell(cell)
          let  movie = filteredData![indexpath!.row]
            let detailViewController = segue.destinationViewController as! DetailedViewController
        detailViewController.Movie = movie
        }       
        else
        {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            let movie = filteredData![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailedViewController
            detailViewController.Movie = movie
        }
        
    }
    
   /** let totalColors: Int = 100
    func colorForIndexPath(indexPath: NSIndexPath) -> UIColor {
        if indexPath.row >= totalColors {
            return UIColor.blackColor()	// return black if we get an unexpected row index
        }
        
        var hueValue: CGFloat = CGFloat(indexPath.row) / CGFloat(totalColors)
        return UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    */
    
   /** func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
            return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        tableView.reloadData()
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
*/
}