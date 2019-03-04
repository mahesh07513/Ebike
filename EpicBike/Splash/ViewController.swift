//
//  ViewController.swift
//  EpicBike
//
//  Created by Apple on 04/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork
let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
class ViewController: UIViewController,UITextFieldDelegate,URLSessionDelegate {

    @IBOutlet weak var mobileNo: UITextField!
    
    @IBOutlet weak var signinVar: UIButton!
    let rebutton = UIButton(type: UIButtonType.custom)


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // notification of for/background
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        reachNetwork()//network checking
        
//        rebutton.setTitle("return", for: UIControlState())
//        rebutton.setTitleColor(UIColor.black, for: UIControlState())
//        rebutton.frame = CGRect(x: 0, y: 163, width: 106, height: 53)
//        rebutton.adjustsImageWhenHighlighted = false
//        rebutton.addTarget(self, action: #selector(ViewController.Done(_:)), for: UIControlEvents.touchUpInside)
        
        // mobile no boarder
        mobileNo.layer.cornerRadius = 20.0
        mobileNo.layer.borderWidth = 2.0
        mobileNo.layer.borderColor = UIColor.black.cgColor
        
        // sign in  boarder
        signinVar.layer.cornerRadius = 20.0
        signinVar.layer.borderWidth = 2.0
        signinVar.layer.borderColor = UIColor.black.cgColor
        
        // text field images setup
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "mobile_img")
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView.frame = CGRect(x: 5, y: 0, width: 35  , height: 35)
        mobileNo.leftViewMode = .always
        mobileNo.leftView = leftView
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       
        
        mobileNo.delegate=self
        
        
        
        
        
    }
    @objc func didBecomeActive() {
        print("did become active login")
    }
    
    @objc func willEnterForeground() {
        print("will enter foreground login")
    }
    
    

    @IBAction func signinAct(_ sender: Any) {
        if (mobileNo.text?.isEmpty)!{
            let alert = UIAlertController(title: "Login", message: "Please Enter Your Mobile No.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            var request = URLRequest(url: URL(string: "https://epickbikes.com/api/v1/login/requestOTP")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let postString="{\"phoneNumber\": \"+91\(String(describing: mobileNo.text!))\"}"
            print("json is : \(postString)")
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.darkGray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            if self.view.frame.origin.y != 0 {
                mobileNo.resignFirstResponder()
                self.view.frame.origin.y = 0
            }
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
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let otpViewController = storyBoard.instantiateViewController(withIdentifier: "OTP") as! OTPViewController
                                otpViewController.mobileno_VC = self.mobileNo.text!
                                self.present(otpViewController, animated:true, completion:nil)
                            }
                        }
                        else{
                             DispatchQueue.main.async{
                                activityIndicator.stopAnimating()
                            }
                            print("success false")
                            let msg = json["message"] as? String
                            // create the alert
                            let alert = UIAlertController(title: "Login", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                            
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
        }
    }
    func reachNetwork(){
        print("in reach login")
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected login")
            let alert = UIAlertController(title: "Network ", message: "Plese Switch ON your Mobile Data(or)WiFi.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        case .online(.wwan):
            print("Connected via WWAN login")
        case .online(.wiFi):
            print("Connected via WiFi login ")
            getSSID()
        }
    }
    func getSSID()  {
        print("in ssid login")
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    let ssidName = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    print("ssid name is :\(ssidName!)")
                    break
                }
            }
        }else{
            print("in else came")
        }
        //  return ssid
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10          // set your need
        let currentString: NSString = mobileNo.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
             
                print ("diff is : \(self.view.frame.height-mobileNo.frame.origin.y) , and key board height is : \(keyboardSize.height) " )
                if(self.view.frame.height - (mobileNo.frame.origin.y + mobileNo.frame.height) < keyboardSize.height){
                    if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= keyboardSize.height-80
                    }
                }
                
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        
        
        
    }
    
    
    
    
}

