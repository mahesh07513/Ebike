//
//  TripStartViewController.swift
//  EpicBike
//
//  Created by Apple on 26/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit
import MapKit

class TripStartViewController: BaseViewController {

    @IBOutlet weak var tripMapView: MKMapView!
    
    
    @IBOutlet weak var helpTrip: UIButton!
    
    
    @IBOutlet weak var cltrip: UIButton!
    
    @IBOutlet weak var endTripVar: UIButton!
    
    var LocationManager = CLLocationManager()
    
    var authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius:Double = 1000
    var tittleArray : [String] = [String()]
    var fleetArray : [String] = [String()]
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()

        // Do any additional setup after loading the view.
        
        
        // button UI
        endTripVar.layer.cornerRadius = 20.0
        endTripVar.layer.borderWidth = 2.0
        endTripVar.layer.borderColor = UIColor.white.cgColor
        
      
        
        helpTrip.layer.cornerRadius = helpTrip.frame.size.width/2
        helpTrip.layer.borderWidth = 2.0
        helpTrip.layer.borderColor = UIColor.black.cgColor
        
        
        //location Code
        LocationManager.pausesLocationUpdatesAutomatically = false
        LocationManager.allowsBackgroundLocationUpdates = true
        tripMapView.delegate=self
        LocationManager.delegate=self
        configureLocationServices()
        
    }
    

    @IBAction func helpTriopAct(_ sender: Any) {
       
        
        
    }
    
    @IBAction func curLocAct(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    
    @IBAction func endTripAct(_ sender: Any) {
        
    }
}

extension TripStartViewController:MKMapViewDelegate{
    func centerMapOnUserLocation(){
        guard let coordinate = LocationManager.location?.coordinate else{ return }
        let coorinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        tripMapView.setRegion(coorinateRegion, animated: true)
        
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
extension TripStartViewController:CLLocationManagerDelegate{
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
