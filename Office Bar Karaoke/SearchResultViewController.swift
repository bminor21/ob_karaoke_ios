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
    
    var results: JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self;
        
        initializeIndicator()
        setupHttpRequest()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: - Navigation
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "rvcSegue") {
            let dvc = segue.destination as! RequestSongViewController;
            dvc.artistSelection = results[selectedItem]["artist"].stringValue
            dvc.songSelection = results[selectedItem]["title"].stringValue
        }
    }
    
    //MARK: - Behind the scense
    func initializeIndicator() -> Void{
        
        let screenSize: CGRect = UIScreen.main.bounds
        let size = screenSize.width * 0.5
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: size, height: size )
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubview(toFront: self.view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        indicator.startAnimating()
    }
    
    func displayError()->Void{
        
        let alertController = UIAlertController(title: "Not Found", message: "Your search returned 0 results.", preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "Okay", style: .default ) { (action: UIAlertAction )->Void in }
        alertController.addAction(okay)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - URL Connection
    func setupHttpRequest() -> Void {
        
        let endPoint: String = "https://obkaraoke.herokuapp.com/?" + self.searchTerm
        guard let url = URL(string: endPoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let session = URLSession.shared
        let req = URLRequest( url:url )
        session.dataTask(with: req, completionHandler: { ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
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
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            });
            
        }).resume()
    }
    

    //MARK: - Table View Actions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard results == JSON.null else {
            return results.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if (cell != nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                reuseIdentifier: "Cell")
        }
    
        cell?.textLabel!.text = results[(indexPath as NSIndexPath).row]["title"].stringValue
        cell?.detailTextLabel!.text = results[(indexPath as NSIndexPath).row]["artist"].stringValue

        
        return cell!
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedItem = (indexPath as NSIndexPath).row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "rvcSegue", sender: self)
        
    }

}
