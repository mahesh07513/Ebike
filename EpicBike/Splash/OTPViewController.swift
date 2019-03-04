//
//  OTPViewController.swift
//  EpicBike
//
//  Created by Apple on 05/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController,UITextFieldDelegate,URLSessionDelegate {
    
    var mobileno_VC=String()
    
    @IBOutlet weak var otp_1: UITextField!
    
    @IBOutlet weak var otp_2: UITextField!
    
    @IBOutlet weak var otp_3: UITextField!
    
    @IBOutlet weak var otp_4: UITextField!
    
    @IBOutlet weak var confirm_otp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print (mobileno_VC)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        otp_1.delegate=self
        otp_2.delegate=self
        otp_3.delegate=self
        otp_4.delegate=self
        
        
        
        otp_1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otp_2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otp_3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otp_4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        // showdow and corner radius
        otp_1.layer.cornerRadius = 10.0
        otp_1.layer.borderWidth = 2.0
        otp_1.layer.borderColor = UIColor.black.cgColor
        otp_1.clipsToBounds = false
        otp_1.layer.shadowOpacity=0.5
        otp_1.layer.shadowOffset = CGSize(width: 0, height: 0)
        otp_1.layer.shadowColor = UIColor.black.cgColor
        
        otp_2.layer.cornerRadius = 10.0
        otp_2.layer.borderWidth = 2.0
        otp_2.layer.borderColor = UIColor.black.cgColor
        otp_2.clipsToBounds = false
        otp_2.layer.shadowOpacity=0.5
        otp_2.layer.shadowOffset = CGSize(width: 0, height: 0)
        otp_2.layer.shadowColor = UIColor.black.cgColor
        
        otp_3.layer.cornerRadius = 10.0
        otp_3.layer.borderWidth = 2.0
        otp_3.layer.borderColor = UIColor.black.cgColor
        otp_3.clipsToBounds = false
        otp_3.layer.shadowOpacity=0.5
        otp_3.layer.shadowOffset = CGSize(width: 0, height: 0)
        otp_3.layer.shadowColor = UIColor.black.cgColor
        
        otp_4.layer.cornerRadius = 10.0
        otp_4.layer.borderWidth = 2.0
        otp_4.layer.borderColor = UIColor.black.cgColor
        otp_4.clipsToBounds = false
        otp_4.layer.shadowOpacity=0.5
        otp_4.layer.shadowOffset = CGSize(width: 0, height: 0)
        otp_4.layer.shadowColor = UIColor.black.cgColor
    
        confirm_otp.layer.cornerRadius = 20.0
        confirm_otp.layer.borderWidth = 2.0
        confirm_otp.layer.borderColor = UIColor.black.cgColor
        
        
        
        
        
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func BackAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func confirmOtpAct(_ sender: Any) {
        if((otp_1.text?.isEmpty)! || (otp_2.text?.isEmpty)! || (otp_3.text?.isEmpty)! || (otp_4.text?.isEmpty)!){
            let alert = UIAlertController(title: "OTP ", message: "Plese Enter Your OTP.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            
            var request = URLRequest(url: URL(string: "https://epickbikes.com/api/v1/login/verifyOTP")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let postString="{\"phoneNumber\": \"+91\(mobileno_VC)\",\"otp\":\"\(otp_1.text!)\(otp_2.text!)\(otp_3.text!)\(otp_4.text!)\"}"
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
                                
                                //{"success":true,"message":"","data":{"access_token":"09b20aa334904abde506725133bee7cc:b581854ac18987f7485db8c7cef58df9"}}
                                
                                let alert = UIAlertController(title: "Verify OTP ", message: "Success ", preferredStyle: UIAlertControllerStyle.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
//                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                                let otpViewController = storyBoard.instantiateViewController(withIdentifier: "OTP") as! OTPViewController
//                                otpViewController.mobileno_VC = self.mobileNo.text!
//                                self.present(otpViewController, animated:true, completion:nil)
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
    
    
    @IBAction func resendOtpAct(_ sender: Any) {
        var request = URLRequest(url: URL(string: "https://epickbikes.com/api/v1/login/requestOTP")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let postString="{\"phoneNumber\": \"+91\(mobileno_VC)\"}"
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
//                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                            let otpViewController = storyBoard.instantiateViewController(withIdentifier: "OTP") as! OTPViewController
//                            otpViewController.mobileno_VC = self.mobileNo.text!
//                            self.present(otpViewController, animated:true, completion:nil)
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
    func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if  text?.count == 1 {
            switch textField{
            case otp_1:
                otp_2.becomeFirstResponder()
            case otp_2:
                otp_3.becomeFirstResponder()
            case otp_3:
                otp_4.becomeFirstResponder()
            case otp_4:
                otp_4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case otp_1:
                otp_1.becomeFirstResponder()
            case otp_2:
                otp_1.becomeFirstResponder()
            case otp_3:
                otp_2.becomeFirstResponder()
            case otp_4:
                otp_3.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.text = ""
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1          // set your need
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            if(self.view.frame.height - (otp_1.frame.origin.y + otp_1.frame.height) < keyboardSize.height || self.view.frame.height - (otp_2.frame.origin.y + otp_2.frame.height)  < keyboardSize.height || self.view.frame.height - (otp_3.frame.origin.y + otp_3.frame.height)  < keyboardSize.height || self.view.frame.height - (otp_4.frame.origin.y + otp_4.frame.height)  < keyboardSize.height){
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
