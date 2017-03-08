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
        searchButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
   // MARK: - Interface Actions
    @IBAction func toggleSearchType(_ sender: AnyObject) {
        
        switch self.queryType.selectedSegmentIndex{
            case 0 : searchType = "song"
            break
            case 1 : searchType = "artist"
            break
            default : searchType = "song"
        }
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "searchSegue") {
            let svc = segue.destination as! SearchResultViewController;
            
            svc.searchTerm = prepareURLString(searchField.text!, searchType: self.searchType)
            
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any!) -> Bool {
        if identifier == "searchSegue" {
            
            if (searchField.text!.isEmpty && queryType.selectedSegmentIndex != 2 ) {
                
                let alertController = UIAlertController(title: "Error", message: "Search term cannot be empty.", preferredStyle: .alert)
                
                let okay = UIAlertAction(title: "Okay", style: .default ) { (action: UIAlertAction )->Void in }
                alertController.addAction(okay)
                present(alertController, animated: true, completion: nil)
                
                return false
            } else {
                return true
            }
        }
        
        // by default, transition
        return true
    }
    
    //MARK: - Unwind to this point
    @IBAction func unwindToContainerVC(_ segue: UIStoryboardSegue) {
        
    }
    
}

