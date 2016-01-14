//
//  ViewController.swift
//  Office Bar Karaoke
//
//  Created by Brett Minor on 11/18/15.
//  Copyright © 2015 Brett Minor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchTerm: UITextField!
    
    @IBOutlet weak var queryType: UISegmentedControl!
    @IBOutlet weak var searchButton: UIButton!
    
    var searchType:String = "song"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.searchField.delegate = self
        
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
   // MARK: - Interface Actions
    @IBAction func toggleSearchType(sender: AnyObject) {
        
        switch self.queryType.selectedSegmentIndex{
            case 0 : searchType = "song"
            break
            case 1 : searchType = "artist"
            break
            default : searchType = "all"
        }
        
    }

    
    // MARK: - String Functions
    func prepareURLString(str: String ) -> String {
        let temp = searchType.stringByAppendingString("=")
        var formattedString = str
        
        if( searchType != "all" ){
            let chars : Set<Character> = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890'".characters)
            formattedString = String(str.characters.filter { chars.contains($0) })
            formattedString = formattedString.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            formattedString = formattedString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        } else {
            formattedString = "true";
        }
                
        return temp.stringByAppendingString(formattedString)
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "searchSegue") {
            let svc = segue.destinationViewController as! SearchResultViewController;
            
            svc.searchTerm = prepareURLString(searchField.text!)
            
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "searchSegue" {
            
            if (searchField.text!.isEmpty && queryType.selectedSegmentIndex != 2 ) {
                
                let alertController = UIAlertController(title: "Error", message: "Search term cannot be empty.", preferredStyle: .Alert)
                
                let okay = UIAlertAction(title: "Okay", style: .Default ) { (action: UIAlertAction )->Void in }
                alertController.addAction(okay)
                presentViewController(alertController, animated: true, completion: nil)
                
                return false
            } else {
                return true
            }
        }
        
        // by default, transition
        return true
    }
    
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
        
    }
    
}

