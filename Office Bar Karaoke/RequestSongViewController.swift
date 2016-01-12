//
//  RequestSongViewController.swift
//  Office Bar Karaoke
//
//  Created by Brett Minor on 1/11/16.
//  Copyright © 2016 Brett Minor. All rights reserved.
//

import UIKit

class RequestSongViewController: UIViewController {

    var songSelection: String!
    var artistSelection: String!
    var isSuccessful: Bool!
    
    @IBOutlet weak var songField: UILabel!
    @IBOutlet weak var artistField: UILabel!
    
    @IBOutlet weak var singerField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.songField.text = songSelection;
        self.artistField.text = artistSelection;
        self.isSuccessful = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRequest(sender: AnyObject) {
        let name = singerField.text!
        
        
        if( formatString(name).isEmpty ){
            displayError();
            return;
        }
        
        
        let endPoint: String = "http://officebarkaraoke.netne.net/request.php?song=" + formatString(songSelection) + "&artist=" + formatString(artistSelection) + "&name=" + formatString(name)
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
                return
            }
            
            guard error == nil else {
                print(error)
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            let json = JSON(data: responseData)
            
            if( json["status"].boolValue ){
                self.isSuccessful = true
            }
            
            dispatch_async(dispatch_get_main_queue(), {
            
                let alertController = UIAlertController(title: "Error", message: self.getMessageText(self.isSuccessful), preferredStyle: .Alert)
                
                let home = UIAlertAction(title: "Okay", style: .Default, handler: {action in
                    
                    self.performSegueWithIdentifier("returnHome", sender: nil)
                });
                
                alertController.addAction(home);
                self.presentViewController(alertController, animated: true, completion: nil)
            });
            
        }).resume()

    }
    
    func getMessageText( success:Bool)->String{
        var buf: String!
        
        if(success){
            buf = "Your submittion was successful.\n\n"
            
        } else {
            buf = "There was an error processing your request. Please fill out a blank paper and hand it to the DJ.\n\n"
        }
        
        buf = buf + "Click Okay to return to the main screen"
        
        return buf
    }
    
    func formatString( toFormat: String)-> String {
        var formattedString:String!
        
        let chars : Set<Character> = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890'".characters)
        formattedString = String(toFormat.characters.filter { chars.contains($0) })
        formattedString = formattedString.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        formattedString = formattedString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        return formattedString
    }
    
    func displayError()->Void{
        
        let alertController = UIAlertController(title: "Error", message: "Name field cannot be empty", preferredStyle: .Alert)
        
        let okay = UIAlertAction(title: "Okay", style: .Default ) { (action: UIAlertAction )->Void in }
        alertController.addAction(okay)
        presentViewController(alertController, animated: true, completion: nil)
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
