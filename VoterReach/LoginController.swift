//
//  LoginController.swift
//  VoterReach
//
//  Created by Giovanni Ruiz on 1/19/18.
//  Copyright © 2018 VoterReach. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    //URL to our web service
    let URL_STRING = "https://voterreach.org/cgi-bin/login.php"
    
    let preferences = UserDefaults.standard
    
    var userid = ""
    
    var mode = ""
    
    @IBOutlet weak var textFieldCode: UITextField!
    
    @IBAction func buttonCanvas(send: UIButton){
        send.isEnabled = false
        
        self.mode = "canvas"
        
        connect()
         
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            send.isEnabled = true
        }
    }
    //Button action method
    @IBAction func buttonStart(sender: UIButton) {
        sender.isEnabled = false
        self.mode = "phonebank"
        
        connect()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            sender.isEnabled = true
        
        }
        
    }
    
    
    func connect(){
        
        ///created NSURL
        let requestURL = NSURL(string: URL_STRING)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        let campaigncode=textFieldCode.text

        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "campaigncode="+campaigncode!+"&pbuuid="+userid + "&mode=" + self.mode;
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            let results = String(data: data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            
            var result = results.components(separatedBy: ",")
            
            
            if result[0] == "True" {
                
                var activities = ""
                
                for i in 1..<(result.count){
                
                    activities += result[i]
                    activities += ","
                    
                }

                
                activities = activities.substring(to: activities.index(before: activities.endIndex))
                
                self.preferences.set(self.mode, forKey: "mode")
                self.preferences.set(activities, forKey: "activities")
                self.preferences.set(campaigncode, forKey: "code")
                self.preferences.synchronize()
                
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "LogIn", sender: LoginController.self)
                }
                
                
                
            }else if (result[0] == "False" ){
                
                OperationQueue.main.addOperation {
                    
                    let alert = UIAlertController(title: "Login Error", message: "You have connected but have an invalid Campaign Code. Remember that Campaign Codes are case sensitive.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }
                
            }
            else if (result[0] == "Blocked" ){
                
                OperationQueue.main.addOperation {
                    
                    let alert = UIAlertController(title: "Login Error", message: "Please contact your campaign manager.", preferredStyle: .alert)
                    
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
        

        self.userid = String(preferences.integer(forKey: "userid"))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

