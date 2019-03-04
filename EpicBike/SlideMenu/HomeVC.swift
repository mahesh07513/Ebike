//
//  HomeVC.swift
//  EpicBike
//
//  Created by Apple on 07/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit
import MapKit

class HomeVC: BaseViewController {

    @IBOutlet weak var mapVar: MKMapView!
    
    var LocationManager = CLLocationManager()
    
    var authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius:Double = 1000
    var tittleArray : [String] = [String()]
    var fleetArray : [String] = [String()]

    
    @IBOutlet weak var current_loc: UIButton!
    
    @IBOutlet weak var un_lock: UIButton!
    
    
    @IBOutlet weak var help_menu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        // button UI
        un_lock.layer.cornerRadius = 20.0
        un_lock.layer.borderWidth = 2.0
        un_lock.layer.borderColor = UIColor.white.cgColor
        
        current_loc.layer.cornerRadius = current_loc.frame.size.width/2
        current_loc.layer.borderWidth = 2.0
        current_loc.layer.borderColor = UIColor.black.cgColor
        
        help_menu.layer.cornerRadius = help_menu.frame.size.width/2
        help_menu.layer.borderWidth = 2.0
        help_menu.layer.borderColor = UIColor.black.cgColor
        
        
        //location Code
        LocationManager.pausesLocationUpdatesAutomatically = false
        LocationManager.allowsBackgroundLocationUpdates = true
        mapVar.delegate=self
        LocationManager.delegate=self
        configureLocationServices()
        
        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 17.23, longitude: 73.50)
//        mapVar.addAnnotation(annotation)
        
        getFleets()
        
   
        
        
    }
    
    func getFleets(){
        
        var request = URLRequest(url: URL(string: "https://epickbikes.com/api/v1/fleets/")!)
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
                    print("error=\(error!.localizedDescription)")
                    activityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Get Bikes", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating()
                            self.tittleArray.removeAll()
                            self.fleetArray.removeAll()
                            print("success true")
                            let fleets = json["data"] as? [[String : Any]]
                            for i in 0 ..< fleets!.count {
                                print("data : \(fleets![i])")
                                self.tittleArray += [ (fleets![i]["name"] as! NSString) as String]
                                self.fleetArray += [ (fleets![i]["fleetId"] as! NSString) as String]
                                let annotation = MKPointAnnotation()
                                annotation.coordinate = CLLocationCoordinate2D(latitude: fleets![i]["lat"] as! CLLocationDegrees, longitude: fleets![i]["lng"] as! CLLocationDegrees)
                                annotation.title = (fleets![i]["name"] as! String)
                                self.mapVar.addAnnotation(annotation)
                                
                            }
 
                            

                        }
                    }
                    else{
                        DispatchQueue.main.async{
                            activityIndicator.stopAnimating()
                        }
                        print("success false")
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func currentLocAct(_ sender: Any) {
        
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
        
    }
    
    @IBAction func unlockAct(_ sender: Any) {
    }
    
    @IBAction func menuAct(_ sender: Any) {
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        //Pin clicked, do your stuff here
        print("pin clicked")
        
        let annotation = view.annotation
        let selectTitle = annotation?.title
        
        print("fleet arry : \(fleetArray) , tittle Array :  \(tittleArray)")
        
        if let index = tittleArray.index(of: selectTitle!! ) {
            print("the selected index is : \(index) , and select fleet \(fleetArray[index])" )
            getBikesofFleets(fleetId: fleetArray[index],fleetName: selectTitle!!)
            
        }
        
        
    }
    
    func getBikesofFleets(fleetId:String,fleetName:String){
        
        var request = URLRequest(url: URL(string: "https://epickbikes.com/api/v1/bikes/")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let postString="{\"access_token\": \"09b20aa334904abde506725133bee7cc:b581854ac18987f7485db8c7cef58df9\",\"orgId\":\"test\",\"fleetId\":\"\(fleetId)\"}"
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
                    activityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Get Bikes", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating()
                            print("success true")
                            
                            let fleets = json["data"] as? [[String : Any]]
                            if fleets?.count == 1 {
                                let alert = UIAlertController(title: "\(fleetName)", message: "No Bikes Available!", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            }else{
                                
                                print("popup")
                                
                                let popvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bikes") as! BikesPopupViewController
                                popvc.fleetName="\(fleetName)"
                                self.addChildViewController(popvc)
                                popvc.view.frame = self.view.frame
                                self.view.addSubview(popvc.view)
                                popvc.didMove(toParentViewController: self)
                                
                                
//                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                                let otpViewController = storyBoard.instantiateViewController(withIdentifier: "bikes") as! BikesPopupViewController
//                                self.present(otpViewController, animated:true, completion:nil)
                                
                                
                                
                            }
                            
                            
                        }
                    }
                    else{
                        DispatchQueue.main.async{
                            activityIndicator.stopAnimating()
                        }
                        print("success false")
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        
    }
    
   
}

extension HomeVC:MKMapViewDelegate{
    func centerMapOnUserLocation(){
        guard let coordinate = LocationManager.location?.coordinate else{ return }
        let coorinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapVar.setRegion(coorinateRegion, animated: true)
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
           
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            
            let pinImage = UIImage(named: "location_pin")
            let size = CGSize(width: 50, height: 70)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            annotationView.canShowCallout = false
            //annotationView.image = UIImage(named: "location_pin")
            annotationView.image = resizedImage

        }
        
        return annotationView
    }
    
}
extension HomeVC:CLLocationManagerDelegate{
    func configureLocationServices(){
        if(authorizationStatus == .notDetermined){
            LocationManager.requestAlwaysAuthorization()
        }else{
            return
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    
}
