//
//  ProfileViewController.swift
//  EpicBike
//
//  Created by Apple on 13/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var profile_var: UIView!
    
    
    @IBOutlet weak var profile_img: UIImageView!
    
    @IBOutlet weak var profile_name: UILabel!
    
    @IBOutlet weak var profile_phno: UILabel!
    
    @IBOutlet weak var profile_trips: UILabel!
    
    @IBOutlet weak var profile_cals: UILabel!
    
    @IBOutlet weak var profile_co2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profile_var.layer.cornerRadius = 10.0
        profile_var.layer.borderWidth = 2.0
        profile_var.layer.borderColor = UIColor.gray.cgColor
        profile_var.clipsToBounds = false
        profile_var.layer.shadowOpacity=0.5
        profile_var.layer.shadowOffset = CGSize(width: 0, height: 0)
        profile_var.layer.shadowColor = UIColor.black.cgColor
        
        

        // Do any additional setup after loading the view.
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
