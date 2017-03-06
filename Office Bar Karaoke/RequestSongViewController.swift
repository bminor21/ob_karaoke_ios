//
//  RequestSongViewController.swift
//  Office Bar Karaoke
//
//  Created by Brett Minor on 1/11/16.
//  Copyright © 2016 Brett Minor. All rights reserved.
//

import UIKit

class RequestSongViewController: UIViewController, UITextFieldDelegate {

    var songSelection: String!
    var artistSelection: String!
    var isSuccessful: Bool!
    
    @IBOutlet weak var songField: UILabel!
    @IBOutlet weak var artistField: UILabel!
    
    @IBOutlet weak var singerField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.songField.text = songSelection;
        self.artistField.text = artistSelection;
        self.isSuccessful = false
        
        
        self.singerField.delegate = self;
        
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.white.cgColor

    }
    
    //MARK: - Delegation Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRequest(_ sender: AnyObject) {
        let name = singerField.text!
        
        
        if( formatString(name).isEmpty ){
            displayError();
            return;
        }
        
        
        let endPoint: String = "http://officebarkaraoke.netne.net/request.php?song=" + formatString(songSelection) + "&artist=" + formatString(artistSelection) + "&name=" + formatString(name)
        print(endPoint)
        guard let url = URL(string: endPoint) else {
            print("Error: cannot create URL")
            return
        }
        
        
        let session = URLSession.shared
        let req = URLRequest( url:url )
        session.dataTask(with: req, completionHandler: { ( data: Data?, response: URLResponse?, error: NSError?) -> Void in
            
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
            
            if( json["status"].boolValue ){
                self.isSuccessful = true
            }
            
            DispatchQueue.main.async(execute: {
                
                var alertTitle:String!
                if( self.isSuccessful! ){
                    alertTitle = "Success"
                } else {
                    alertTitle = "Error"
                }
            
                let alertController = UIAlertController(title: alertTitle, message: self.getMessageText(self.isSuccessful), preferredStyle: .alert)
                
                let home = UIAlertAction(title: "Okay", style: .default, handler: {action in
                        self.performSegue(withIdentifier: "unwindToMain", sender: self)
                });
                
                alertController.addAction(home);
                self.present(alertController, animated: true, completion: nil)
            });
            
        } as! (Data?, URLResponse?, Error?) -> Void).resume()

    }
    
    func getMessageText( _ success:Bool)->String{
        var buf: String!
        
        if(success){
            buf = "Your song submittion was successful.\n\n"
            
        } else {
            buf = "There was an error processing your request. Please fill out a blank paper and hand it to the DJ.\n\n"
        }
        
        return buf
    }
    
    func displayError()->Void{
        
        let alertController = UIAlertController(title: "Error", message: "Name field cannot be empty.", preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "Okay", style: .default ) { (action: UIAlertAction )->Void in }
        alertController.addAction(okay)
        present(alertController, animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // }
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
