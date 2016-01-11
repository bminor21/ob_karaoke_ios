//
//  SearchResultViewController.swift
//  Office Bar Karaoke
//
//  Created by Brett Minor on 11/20/15.
//  Copyright © 2015 Brett Minor. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDataSource, NSURLConnectionDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [String]()
    var searchTerm: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let endPoint: String = "http://192.168.0.2:8888/search.php?" + searchTerm
        print(endPoint)
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
                self.searchResults.append("Your search did not return any results - ")
                return
            }
            
            guard error == nil else {
                print(error)
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            let json = JSON(data: responseData)
            
            if json.count == 0 {
                self.searchResults.append("Your search did not return any results - ")
            } else {
                
                for i in 0...json.count {
                    let artist = json[i]["artist"].stringValue
                    let song = json[i]["song"].stringValue
                
                    let str = song + "-" + artist
                
                    self.searchResults.append(str)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                });
            
        }).resume()
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell")
        if (cell != nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "Cell")
        }
        
        var result = searchResults[indexPath.row].componentsSeparatedByString("-")
        
        cell?.textLabel!.text = result[0]
        cell?.detailTextLabel!.text = result[1]
        
        return cell!
        
    }

}
