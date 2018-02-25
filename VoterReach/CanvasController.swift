//
//  CanvasController.swift
//  VoterReach
//
//  Created by Giovanni Ruiz on 2/21/18.
//  Copyright © 2018 VoterReach. All rights reserved.
//

import Foundation

import UIKit
import GoogleMaps

class CanvasController: UIViewController , GMSMapViewDelegate{
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    
    let URL_STRING = "https://voterreach.org/cgi-bin/canvas.php"
    
    let preferences = UserDefaults.standard
    var script = ""
    
    var selected_flag = false

    @IBAction func buttonVisit(send: UIButton){
        
        if selected_flag == false{
            
            let alert = UIAlertController(title: "Selection Error", message: "Please select a valid marker.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            
        }else {
        
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "CanvasSurvey", sender: CanvasController.self)
            }
        }
    }
    
    @IBAction func buttonPath(send: UIButton){
        
        print ("Path")
        
    }
    
    @IBAction func buttonScript(send: UIButton){
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
    
    @IBAction func buttonExit(send: UIButton){

        OperationQueue.main.addOperation {
            self.performSegue(withIdentifier: "CanvasLogOut", sender: CanvasController.self)
        }
        
    }
    
    func connect(){
        //let campaigncode = preferences.string(forKey: "CampaignCode")
        let userid = String(preferences.integer(forKey: "userid"))
        let activity = preferences.string(forKey: "Activities")!
        
        ///created NSURL
        let requestURL = NSURL(string: URL_STRING)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "campaigncode=voterreach"+"&pbuuid="+userid+"&activity=" + activity;
        
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
            
            var voters_array = results.components(separatedBy: "*")
            
            for i in 0..<(voters_array.count-1){
                
                var information_array = voters_array[i].components(separatedBy: ":")
                
                var coordinates_array = information_array[1].components(separatedBy: ",")
                
                let name_address_array = information_array[0].components(separatedBy: ",")
                
                
                let camera = GMSCameraPosition.camera(withLatitude: Double(coordinates_array[0])!, longitude: Double(coordinates_array[1])!, zoom: 12.0)
                self.mapView.camera = camera
                
                self.showMarker(position: camera.target, tag: name_address_array)
                
                
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        connect()
        
        mapView.delegate = self
        
        mapView.isUserInteractionEnabled = true
        
    }
    
    func showMarker(position: CLLocationCoordinate2D, tag: [String]){
        let marker = GMSMarker()
        marker.position = position
        marker.title = tag[1]
        marker.snippet = tag[2]
        marker.map = mapView
        marker.userData = tag[0]
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        self.selected_flag = true
        mapView.selectedMarker = marker
        self.preferences.set(marker.userData, forKey: "voterid")
        self.preferences.set(marker.title, forKey: "VoterName")
        self.preferences.synchronize()

        return true
    }
}

