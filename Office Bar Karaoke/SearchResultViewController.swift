//
//  SearchResultViewController.swift
//  Office Bar Karaoke
//
//  Created by Brett Minor on 11/20/15.
//  Copyright © 2015 Brett Minor. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDataSource, NSURLConnectionDelegate, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchTerm: String!
    
    var selectedItem: Int!
    var indicator: UIActivityIndicatorView!
    
    var results: JSON = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self;
        
        initializeIndicator()
        setupHttpRequest()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: - Navigation
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "rvcSegue") {
            let dvc = segue.destinationViewController as! RequestSongViewController;
            dvc.artistSelection = results[selectedItem]["artist"].stringValue
            dvc.songSelection = results[selectedItem]["song"].stringValue
        }
    }
    
    //MARK: - Behind the scense
    func initializeIndicator() -> Void{
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let size = screenSize.width * 0.5
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: size, height: size )
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        indicator.startAnimating()
    }
    
    func displayError()->Void{
        
        let alertController = UIAlertController(title: "Not Found", message: "Your search returned 0 results.", preferredStyle: .Alert)
        
        let okay = UIAlertAction(title: "Okay", style: .Default ) { (action: UIAlertAction )->Void in }
        alertController.addAction(okay)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - URL Connection
    func setupHttpRequest() -> Void {
        
        let endPoint: String = "http://officebarkaraoke.netne.net/search.php?" + self.searchTerm
        guard let url = NSURL(string: endPoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let session = NSURLSession.sharedSession()
        let req = NSURLRequest( URL:url )
        session.dataTaskWithRequest(req, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if( httpResponse.statusCode != 200 ) {
                    print("Received status code \(httpResponse.statusCode)")
                    return
                }
            }
            
            guard let responseData = data else {
                return
            }
            
            guard error == nil else {
                print(error)
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            let json = JSON(data: responseData)
            
            if json.count == 0 {
                self.displayError()
            } else {
                self.results = json;
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            });
            
        }).resume()
    }
    

    //MARK: - Table View Actions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard results == nil else {
            return results.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell")
        if (cell != nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "Cell")
        }
        
        if searchTerm.containsString("song="){
            cell?.textLabel!.text = results[indexPath.row]["song"].stringValue
            cell?.detailTextLabel!.text = results[indexPath.row]["artist"].stringValue
        } else {
            cell?.textLabel!.text = results[indexPath.row]["artist"].stringValue
            cell?.detailTextLabel!.text = results[indexPath.row]["song"].stringValue
        }
        
        return cell!
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedItem = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("rvcSegue", sender: self)
    }

}
