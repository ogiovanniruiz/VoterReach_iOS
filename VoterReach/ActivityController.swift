//
//  ActivityController.swift
//  VoterReach
//
//  Created by Giovanni Ruiz on 2/24/18.
//  Copyright © 2018 VoterReach. All rights reserved.
//

import Foundation
import UIKit

class ActivityController: UIViewController {
    
    //URL to our web service
    let URL_STRING = "https://voterreach.org/cgi-bin/activity.php"
    
    let preferences = UserDefaults.standard
    
    var mode = ""
    
    var activities = [String]()
    
    var code = ""
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func firstActivity(send: UIButton){

        let activity = self.activities[0]
        
        connect(activity: activity)

    }
    
    @IBAction func secondActivity(send: UIButton){

        
        let activity = self.activities[1]
        
        connect(activity: activity)
        

    }
    
    @IBAction func thirdActivity(send: UIButton){

        
        let activity = self.activities[2]
        
        connect(activity: activity)

    }
    
    @IBAction func fourthActivity(send: UIButton){
        
        
        let activity = self.activities[3]
        
        connect(activity: activity)
        
    }
    
    @IBAction func fifthActivity(send: UIButton){
        
        
        let activity = self.activities[4]
        
        connect(activity: activity)
        
    }
    
    @IBAction func sixthActivity(send: UIButton){
        
       let activity = self.activities[5]
        
        connect(activity: activity)
        
    }

    func connect(activity: String){
        
        ///created NSURL
        let requestURL = NSURL(string: URL_STRING)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"

        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "campaigncode="+self.code + "&activity=" + activity;
        
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
                
                let questions = result[1] + "," + result[2] + "," + result[3] + "," + result[4]
                let script_link = result[5]
                let rtype = result[6] + "," + result[7] + "," + result[8] + "," + result[9]
                
                self.preferences.set(questions, forKey: "Questions")
                self.preferences.set(script_link, forKey: "Script_Link")
                self.preferences.set(rtype, forKey: "R_Type")
                self.preferences.set(activity, forKey: "Activities")
                self.preferences.synchronize()
                
                if self.mode == "canvas"{
                    
                    OperationQueue.main.addOperation {
                        self.performSegue(withIdentifier: "CanvasLogIn", sender: LoginController.self)
                    }
                    
                }else if self.mode == "phonebank"{
                    
                    OperationQueue.main.addOperation {
                        self.performSegue(withIdentifier: "CallLogIn", sender: LoginController.self)
                    }
                    
                }
                
            }else if (result[0] == "False" ){
                
                OperationQueue.main.addOperation {
                    
                    let alert = UIAlertController(title: "Login Error", message: "You have connected but have an invalid Campaign Code. Remember that Campaign Codes are case sensitive.", preferredStyle: .alert)
                    
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
        
        
        self.code = preferences.string(forKey: "code")!
        self.mode = preferences.string(forKey: "mode")!
        let activity_string = preferences.string(forKey: "activities")
        
        self.activities = (activity_string?.components(separatedBy: ","))!
        
        for i in 0..<(self.activities.count){
            
            buttons[i].setTitle(self.activities[i], for: .normal)
            buttons[i].layer.cornerRadius = 10
            buttons[i].clipsToBounds = true
            buttons[i].isHidden = false
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

