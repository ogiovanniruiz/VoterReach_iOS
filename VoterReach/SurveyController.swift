//
//  SurveyController.swift
//  VoterReach
//
//  Created by Giovanni Ruiz on 1/20/18.
//  Copyright © 2018 VoterReach. All rights reserved.
//

import UIKit

class SurveyController: UIViewController {
    
    //URL to our web service
    let URL_STRING = "https://voterreach.org/cgi-bin/survey.php"
    
    var answers = [String](arrayLiteral: "N", "N","N","N")
    
    var noanswer = "N"
    
    var badnumber = "N"
    
    var voterid = ""
    
    var voterName = ""
    
    var activity = ""
    
    var type = [String]()
    
    var question = [String]()
    
    let preferences = UserDefaults.standard
    
    @IBOutlet var voterNameReminder: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var selectors: [UISegmentedControl]!
    @IBOutlet var selectorText: [UILabel]!
    
    @IBOutlet var textFieldAnswer: [UITextField]!
    
    @IBOutlet weak var btnNoAnswer: UIButton!
    @IBOutlet weak var btnBadNumber: UIButton!
    
    //Button action method
    @IBAction func buttonQuestA(sender: UIButton) {
        
        OperationQueue.main.addOperation {
            
            if self.type[0] == "s"{
                self.buttons[0].isHidden = true
                self.selectors[0].isHidden = false
            }
        
            if self.answers[0] == "Y" {
                
                self.buttons[0].backgroundColor = UIColor(red: 0.6745, green: 0.1255, blue: 0, alpha: 1.0)
                
                self.answers[0] = "N"
                
            } else  {
                self.answers[0] = "Y"
                self.buttons[0].backgroundColor = UIColor(red: 0.0471, green: 0.2627, blue: 0.4392, alpha: 1.0)
                
            }
        }
        
    }
    
    //Button action method
    @IBAction func buttonQuestB(sender: UIButton) {
        
        OperationQueue.main.addOperation {
            
            if self.type[1] == "s"{
                self.buttons[1].isHidden = true
                self.selectors[1].isHidden = false
            }
        
            if self.answers[1] == "Y" {
                self.buttons[1].backgroundColor = UIColor(red: 0.6745, green: 0.1255, blue: 0, alpha: 1.0)
                
                self.answers[1] = "N"
            } else  {
                self.answers[1] = "Y"
                self.buttons[1].backgroundColor = UIColor(red: 0.0471, green: 0.2627, blue: 0.4392, alpha: 1.0)
                
            }
        }
    }
    
    //Button action method
    @IBAction func buttonQuestC(sender: UIButton) {
        
        OperationQueue.main.addOperation {
            
            if self.type[2] == "s"{
                self.buttons[2].isHidden = true
                self.selectors[2].isHidden = false
            }
            
            
        
            if self.answers[2] == "Y" {
                self.buttons[2].backgroundColor = UIColor(red: 0.6745, green: 0.1255, blue: 0, alpha: 1.0)
                
                self.answers[2] = "N"
            } else  {
                self.answers[2] = "Y"
                self.buttons[2].backgroundColor = UIColor(red: 0.0471, green: 0.2627, blue: 0.4392, alpha: 1.0)
                
            }
        }
    }
    
    //Button action method
    @IBAction func buttonQuestD(sender: UIButton) {
        
        OperationQueue.main.addOperation {
            
            if self.type[3] == "s"{
                self.buttons[3].isHidden = true
                self.selectors[3].isHidden = false
            }
        
            if self.answers[3] == "Y" {
                self.buttons[3].backgroundColor = UIColor(red: 0.6745, green: 0.1255, blue: 0, alpha: 1.0)
                
                self.answers[3] = "N"
            } else  {
                self.answers[3] = "Y"
                self.buttons[3].backgroundColor = UIColor(red: 0.0471, green: 0.2627, blue: 0.4392, alpha: 1.0)
                
            }
        }
        
    }
    
    //Button action method
    @IBAction func buttonNoAnswer(sender: UIButton) {
        
        for i in 0..<(self.question.count){
            
            if((self.type[i] == "s") && (self.question[i] != "")){
                
                self.selectors[i].selectedSegmentIndex = -1
            }
            
        }
        
        OperationQueue.main.addOperation {
        
            if self.noanswer == "Y" {
                self.btnNoAnswer.setImage(UIImage(named: "noanswer.png"), for: [])
                
                self.noanswer = "N"
            } else  {
                self.btnNoAnswer.setImage(UIImage(named: "noanswerblue.png"), for: [])
                self.noanswer = "Y"
                
            }
        }
        
    }
    
    //Button action method
    @IBAction func buttonBadNumber(sender: UIButton) {
        
        for i in 0..<(self.question.count){
            
            if((self.type[i] == "s") && (self.question[i] != "")){
                
                self.selectors[i].selectedSegmentIndex = -1
            }
            
        }
        
        OperationQueue.main.addOperation {
        
            if self.badnumber == "Y" {
                self.btnBadNumber.setImage(UIImage(named: "bad.png"), for: [])
                
                self.badnumber = "N"
            } else  {
                self.btnBadNumber.setImage(UIImage(named: "badblue.png"), for: [])
                self.badnumber = "Y"
                
            }
        }
        
    }
    
    //Button action method
    @IBAction func buttonSave(sender: UIButton) {
        
        sender.isEnabled = false
        
        for i in 0..<(self.question.count){
                
            if((self.type[i] == "s") && (self.question[i] != "")){
                
                if (self.selectors[i].selectedSegmentIndex != -1){
                
                    self.answers[i] = self.selectors[i].titleForSegment(at: self.selectors[i].selectedSegmentIndex)!
                }else{
                    self.answers[i] = ""
                }
            } else if self.type[i] == "t"{
                
                self.answers[i] = self.textFieldAnswer[i].text!
            }
                
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            sender.isEnabled = true
            
        }
        
        if ((noanswer == badnumber) && (noanswer == "Y")){
            let alert = UIAlertController(title: "Invalid Survey Response", message: "No Answer and Bad Number buttons are both selected.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
        }else if((answers.contains("Y")) && ((noanswer == "Y") || (badnumber == "Y"))){
        
            let alert = UIAlertController(title: "Invalid Survey Response", message: "Please check your Survey Responses.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
        }
        else{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let calendar = Calendar.current
            let day = formatter.string(from: date)
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
        
            let time = day + "." + String(hour) + ":" + String(minutes)
        
            let campaigncode = preferences.string(forKey: "CampaignCode")
            let mode = preferences.string(forKey: "mode")
        
            let pbuuid = preferences.string(forKey: "userid")
        
            ///created NSURL
            let requestURL = NSURL(string: URL_STRING)
        
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL! as URL)
        
            //setting the method to post
            request.httpMethod = "POST"
        
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "a1=\(answers[0])"+"&a2=\(answers[1])"+"&a3=\(answers[2])"+"&a4=\(answers[3])"+"&no=\(noanswer)"+"&bad=\(badnumber)"+"&voteruuid=\(voterid)"+"&calldate=\(time)"+"&campaigncode=\(campaigncode!)"+"&pbuuid=\(pbuuid!)"+"&mode=\(mode!)"+"&activity=\(self.activity)";

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
                
                if results == "True"{
                    
                    if mode == "phonebank" {
                    
                        OperationQueue.main.addOperation {
                            self.performSegue(withIdentifier: "Saved", sender: SurveyController.self)
                        }
                    
                    }else if mode == "canvas"{
                        
                        OperationQueue.main.addOperation {
                            self.performSegue(withIdentifier: "CanvasSaved", sender: SurveyController.self)
                        }
                        
                    }
                
                
                
                }
                else {
                    
                    print(results)
                    
                }
                
            }
            //executing the task
            task.resume()
        }

        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.voterid = String(preferences.integer(forKey: "voterid"))
        let questions = preferences.string(forKey: "Questions")
        let rtype = preferences.string(forKey: "R_Type")
        self.voterName = preferences.string(forKey: "VoterName")!
        self.activity = preferences.string(forKey: "Activities")!
        
        
        
        self.question = questions!.components(separatedBy: ",")
        self.type = rtype!.components(separatedBy: ",")
        
        for i in 0..<(self.question.count) {
            
            if self.type[i] == "s"{
                self.selectors[i].isHidden = false
                self.selectorText[i].isHidden = false
                self.selectorText[i].text = question[i]
                self.selectors[i].layer.cornerRadius = 5
            
            }else if self.type[i] == "b"{
            
                buttons[i].setTitle(question[i], for: .normal)
                buttons[i].layer.cornerRadius = 10
                buttons[i].clipsToBounds = true
                buttons[i].isHidden = false
                
            }else if self.type[i] == "t"{

                self.textFieldAnswer[i].isHidden = false
                self.textFieldAnswer[i].placeholder = question[i]
                self.textFieldAnswer[i].layer.cornerRadius = 10
                
            }
        }
        
        OperationQueue.main.addOperation {
            self.voterNameReminder.text = "Responses for " + self.voterName + ":"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
