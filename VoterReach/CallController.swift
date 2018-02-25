//
//  CallController.swift
//  VoterReach
//
//  Created by Giovanni Ruiz on 1/19/18.
//  Copyright © 2018 VoterReach. All rights reserved.
//

import UIKit

class CallController: UIViewController {
    
    //Create URL, Shared Prefs Object, Script and Phone Number Variables.
    let URL_STRING = "https://voterreach.org/cgi-bin/call.php"
    let preferences = UserDefaults.standard
    var script = ""
    var phone = ""
    
    //Create TextOutput Objects.
    @IBOutlet var textFieldVoterName: UILabel!
    @IBOutlet var textFieldNumCalls: UILabel!
    @IBOutlet var textFieldTotalCalls: UILabel!

    
    //Call Button action method
    @IBAction func buttonCall(sender: UIButton) {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if ((1 == 2)&&((hour <= 7) || (hour >= 23))){
            
            let alert = UIAlertController(title: "Call Function Disabled", message: "The call function has been disabled because it is before 7am or after 11pm.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)

        }
        else {
            
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "Called", sender: CallController.self)
            }
            
            let url = URL(string: "tel://" + self.phone)!
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

        }
    }
    
    //Script Button action method.
    @IBAction func buttonScript(sender: UIButton) {
    
        self.script = preferences.string(forKey: "Script_Link")!

        guard let url = URL(string: self.script) else{
            return
        }
        
        if #available(iOS 10.0, *){
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else{
            UIApplication.shared.openURL(url)
        }
        
    }
    
    //Exit Button action method.
    @IBAction func buttonExit(sender: UIButton) {
        
        OperationQueue.main.addOperation {
              self.performSegue(withIdentifier: "LogOut", sender: CallController.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let campaigncode = preferences.string(forKey: "CampaignCode")
        let userid = String(preferences.integer(forKey: "userid"))
        
        let activity = preferences.string(forKey: "Activities")!
        
        print (activity)
  
        ///created NSURL
        let requestURL = NSURL(string: URL_STRING)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "campaigncode="+campaigncode!+"&pbuuid="+userid+"&activity="+activity;
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            //Receive result from server and interpret as String
            let results = String(data: data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            
            //Seperate results by comma seperation
            var result = results.components(separatedBy: ",")
            
            //Assign Full name, Phone Number, VoterID and Gender
            let full_name = result[0] + " " + result[1]
            self.phone = result[2]
            let voterid = result[3]
            let num_calls = result[4]
            let total_calls = result[5]
            
            //Save VoterID to memory
            self.preferences.set(voterid, forKey: "voterid")
            self.preferences.set(full_name, forKey: "VoterName")
            self.preferences.synchronize()
            
            OperationQueue.main.addOperation {
                
                self.textFieldVoterName.text = full_name
                self.textFieldVoterName.textAlignment = .center
                self.textFieldNumCalls.text = "You have made " + num_calls + " calls."
                self.textFieldTotalCalls.text = "The Campaign has made " + total_calls + " total calls."
            }
            
        }
        //executing the task
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
