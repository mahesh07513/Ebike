//
//  ContactViewController.swift
//  EpicBike
//
//  Created by Apple on 14/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    
    
    
    @IBOutlet weak var facebook_vew: UIView!
    
    @IBOutlet weak var instagramView: UIView!
    
    
    @IBOutlet weak var contactus: UIImageView!
    
    @IBOutlet weak var textus: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        facebook_vew.layer.cornerRadius = 15.0
        facebook_vew.layer.borderWidth = 2.0
        facebook_vew.layer.borderColor = UIColor.gray.cgColor
        facebook_vew.clipsToBounds = false
        facebook_vew.layer.shadowOpacity=0.5
        facebook_vew.layer.shadowOffset = CGSize(width: 0, height: 0)
        facebook_vew.layer.shadowColor = UIColor.black.cgColor
        
        
        instagramView.layer.cornerRadius = 15.0
        instagramView.layer.borderWidth = 2.0
        instagramView.layer.borderColor = UIColor.gray.cgColor
        instagramView.clipsToBounds = false
        instagramView.layer.shadowOpacity=0.5
        instagramView.layer.shadowOffset = CGSize(width: 0, height: 0)
        instagramView.layer.shadowColor = UIColor.black.cgColor
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
