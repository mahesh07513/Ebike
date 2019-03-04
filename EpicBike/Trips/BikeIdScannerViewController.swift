//
//  BikeIdScannerViewController.swift
//  EpicBike
//
//  Created by Apple on 20/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit
import AVFoundation


class BikeIdScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate,UITextFieldDelegate {

    @IBOutlet weak var ScanView: UIView!
    
    
    @IBOutlet weak var bikeIdFiled: UITextField!
    
    
    @IBOutlet weak var submitVar: UIButton!
    
    @IBOutlet weak var torchVar: UIButton!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isReading: Bool = false
    
    var isTorch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bikeIdFiled.layer.cornerRadius = 10.0
        bikeIdFiled.layer.borderWidth = 2.0
        bikeIdFiled.layer.borderColor = UIColor.black.cgColor
        bikeIdFiled.clipsToBounds = false
//        bikeIdFiled.layer.shadowOpacity=0.5
//        bikeIdFiled.layer.shadowOffset = CGSize(width: 0, height: 0)
//        bikeIdFiled.layer.shadowColor = UIColor.black.cgColor
        
        submitVar.layer.cornerRadius = 20.0
        submitVar.layer.borderWidth = 2.0
        submitVar.layer.borderColor = UIColor.black.cgColor
        
        torchVar.layer.cornerRadius = torchVar.frame.size.width/2
        torchVar.layer.borderWidth = 2.0
        torchVar.layer.borderColor = UIColor.black.cgColor
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        bikeIdFiled.delegate=self
        
        
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "cycle")
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRect(x: 0, y: 0, width: bikeIdFiled.frame.width/4, height: bikeIdFiled.frame.height)
        leftImageView.frame = CGRect(x: 5, y: 5, width: (bikeIdFiled.frame.width/4)-10  , height: bikeIdFiled.frame.height-10)
        bikeIdFiled.leftViewMode = .always
        bikeIdFiled.leftView = leftView
        
        ScanView.layer.cornerRadius = 5;
        captureSession = nil;
        Scannig()
    }
    func Scannig(){
        if !isReading {
            if (self.startReading()) {
               print("Scanning for QR Code...")
            }
        }
        else {
            stopReading()
            print("stoping for QR Code...")
            //btnStartStop.setTitle("Start", for: .normal)
        }
        isReading = !isReading
        
    }
    func startReading() -> Bool {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            // Do the rest of your work...
        } catch let error as NSError {
            // Handle any errors
            print(error)
            return false
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = ScanView.layer.bounds
        ScanView.layer.addSublayer(videoPreviewLayer)
        
        /* Check for metadata */
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
        print(captureMetadataOutput.availableMetadataObjectTypes)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureSession?.startRunning()
        
        return true
    }
    func stopReading() {
        captureSession?.stopRunning()
        captureSession = nil
        videoPreviewLayer.removeFromSuperlayer()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        for data in metadataObjects {
            let metaData = data as! AVMetadataObject
            //print(metaData.description)
            let transformed = videoPreviewLayer?.transformedMetadataObject(for: metaData) as? AVMetadataMachineReadableCodeObject
            if let unwraped = transformed {
                //print(" this is scan value : \(unwraped.stringValue!)")
                //lblString.text = unwraped.stringValue
                bikeIdFiled.text=unwraped.stringValue!
                
               // btnStartStop.setTitle("Start", for: .normal)
                //self.performSelector(onMainThread: #selector(stopReading), with: nil, waitUntilDone: false)
                //isReading = false;
            }
        }
    }

    @IBAction func torchOnAct(_ sender: Any) {
        if isTorch == false {
            torchVar.setImage(UIImage.init(named: "flash_off"), for: .normal)
            isTorch=true
            toggleFlash()
            
        }else{
            isTorch=false
            torchVar.setImage(UIImage.init(named: "flash_on"), for: .normal)
            toggleFlash()

        }
        
    }
    func toggleFlash() {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasTorch {
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOnWithLevel(1.0)
                device.torchMode = torchOn ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("error")
            }
        }
    }
    
    
    
    @IBAction func submitAct(_ sender: Any) {
        if((bikeIdFiled.text?.isEmpty)! ){
            let alert = UIAlertController(title: "Booking ", message: "Plese Enter BikeId.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            
            var request = URLRequest(url: URL(string: "https://epickbikes.com/api/v1/bikes/\(bikeIdFiled.text!)")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let postString="{\"access_token\": \"09b20aa334904abde506725133bee7cc:b581854ac18987f7485db8c7cef58df9\",\"orgId\":\"test\"}"
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
                                
                                //let status = json["data"]!["status"] as? String
                                let status = "AVAILABLE"
                                print("status is : \(status)")
                                
                                if status == "UNAVAILABLE" {
                                    
                                    let alert = UIAlertController(title: "Booking ", message: "Bike is UNAVAILABLE .", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    
                                }
                                else if status == "BOOKED" {
                                    
                                    let alert = UIAlertController(title: "Booking ", message: "Bike is already in trip, so please select another Bike.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                else if status == "AVAILABLE" {
                                    
                                    let popvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "confirm") as! ConfirmBikeViewController
                                    popvc.bikeid_pass = "#1234567"
                                    popvc.range_pass = "20km"
                                    self.addChildViewController(popvc)
                                    popvc.view.frame = self.view.frame
                                    self.view.addSubview(popvc.view)
                                    popvc.didMove(toParentViewController: self)
                                    
                                    
                                    
//                                    let alertController = UIAlertController(title: "Get Set Go !", message: "set the switches to Room", preferredStyle: .alert)
//                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {  UIAlertAction in
//
////                                        DispatchQueue.main.async{
////                                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
////                                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "swtype") as! SwitchViewController
////                                            self.present(nextViewController, animated:true, completion:nil)
////                                        }
//                                    }
//                                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { UIAlertAction in
//                                        NSLog("Cancel Pressed")
//                                    }
//                                    // Add the actions
//                                    alertController.addAction(okAction)
//                                    alertController.addAction(cancelAction)
//                                    // Present the controller
//                                    self.present(alertController, animated: true, completion: nil)
//
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
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
            
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 10          // set your need
//        let currentString: NSString = bikeIdFiled.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//
//        return newString.length <= maxLength
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            print ("diff is : \(self.view.frame.height-bikeIdFiled.frame.origin.y) , and key board height is : \(keyboardSize.height) " )
            if(self.view.frame.height - (bikeIdFiled.frame.origin.y + bikeIdFiled.frame.height) < keyboardSize.height){
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
        
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//            let compSepByCharInSet = string.components(separatedBy: aSet)
//            let numberFiltered = compSepByCharInSet.joined(separator: "")
//            return string == numberFiltered
//        }
        
    }
    
    
}
