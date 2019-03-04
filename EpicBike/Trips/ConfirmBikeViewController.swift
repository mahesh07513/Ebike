//
//  ConfirmBikeViewController.swift
//  EpicBike
//
//  Created by Apple on 20/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class ConfirmBikeViewController: UIViewController {
    
    var bikeid_pass = String()
    var range_pass = String()
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lableView: UIView!
    @IBOutlet weak var bikeid: UILabel!
    @IBOutlet weak var range: UILabel!
    
    
    @IBOutlet weak var cancelVar: UIButton!
    
    @IBOutlet weak var confirmVar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bikeid.text = bikeid_pass
        range.text = range_pass
        
        topView.layer.cornerRadius = 10.0
        lableView.layer.cornerRadius = 10.0
        lableView.layer.borderWidth = 2
        lableView.layer.borderColor = UIColor.black.cgColor
        
        cancelVar.layer.borderWidth = 2
        cancelVar.layer.borderColor = UIColor.black.cgColor
        
        confirmVar.layer.borderWidth = 2
        confirmVar.layer.borderColor = UIColor.black.cgColor
        
        
        
        
        
    }
    

    @IBAction func cancelAct(_ sender: Any) {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
    }
    
    @IBAction func confirmAct(_ sender: Any) {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let tripViewController = storyBoard.instantiateViewController(withIdentifier: "tripstart") as! TripStartViewController
        //tripViewController.mobileno_VC = self.mobileNo.text!
        self.present(tripViewController, animated:true, completion:nil)
        
        /*
        var request = URLRequest(url: URL(string: "https://epickbikes.com/api/v1/trips/start")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let postString="{\"access_token\": \"09b20aa334904abde506725133bee7cc:b581854ac18987f7485db8c7cef58df9\",\"orgId\":\"test\",\"bikeId\":\"\(bikeid.text!)\"}"
        print("json is : \(postString)")
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.darkGray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        DispatchQueue.main.async(){
            let start:TimeInterval = NSDate.timeIntervalSinceReferenceDate
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    let timeResponse:TimeInterval = NSDate.timeIntervalSinceReferenceDate - start
                    print("time difference is :: \(timeResponse)")
                    print("error=\(String(describing: error?.localizedDescription))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    
                    
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString!)")
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    let success = json["success"] as? Bool
                    if success == true  {
                        DispatchQueue.main.async{
                            activityIndicator.stopAnimating()
                            print("success true")
                            //redirect
                            
                            
                        }
                    }
                    else{
                        DispatchQueue.main.async{
                            activityIndicator.stopAnimating()
                        }
                        print("success false")
                        let msg = json["message"] as? String
                        // create the alert
                        let alert = UIAlertController(title: "Booking", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        */
        
        
        
    }
    
}
