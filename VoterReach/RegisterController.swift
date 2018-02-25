//
//  ViewController.swift
//  VoterReach
//
//  Created by Giovanni Ruiz on 1/18/18.
//  Copyright © 2018 VoterReach. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    //URL to our web service
    let URL_STRING = "https://voterreach.org/cgi-bin/register.php"
    
    let userid = String(arc4random())
    
    let preferences = UserDefaults.standard
    
    let has_registered = "TRUE"
    
    //TextFields declarations
    @IBOutlet weak var textFieldName: UITextField!
    
    //Button action method
    @IBAction func buttonRegister(sender: UIButton) {
        
        sender.isEnabled = false
        
        ///created NSURL
        let requestURL = NSURL(string: URL_STRING)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        let username=textFieldName.text

        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "pbname="+username!+"&pbuuid="+userid;
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            sender.isEnabled = true
            
        }
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            let result = String(data: data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            
            if result == "True" {
                
                self.preferences.set(self.has_registered, forKey: "hasregistered")
                
                self.preferences.synchronize()
                
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "registered", sender: RegisterController.self)
                
                }
            }
            else {
                print ("Registration Error")
                
                OperationQueue.main.addOperation {
                    
                    let alert = UIAlertController(title: "Registration Error", message: "Please enter your name for registration.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }
            }
            
            
        }
        //executing the task
        task.resume()
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if preferences.string(forKey: "hasregistered") == nil {
            
            preferences.set(userid, forKey: "userid")
            
            preferences.synchronize()
            
        } else {
            
            let registered = preferences.string(forKey: "hasregistered")
            
            if registered == "TRUE"{
                
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "registered", sender: RegisterController.self)
                    
                }
            } else {
                
                print ("Not registered")
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

