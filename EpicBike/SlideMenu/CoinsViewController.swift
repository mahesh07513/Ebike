//
//  CoinsViewController.swift
//  EpicBike
//
//  Created by Apple on 13/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class CoinsViewController: BaseViewController {

    @IBOutlet weak var coins_view_car: UIView!
    
    
    @IBOutlet weak var coinsCount: UILabel!
    
    
    @IBOutlet weak var coins_text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        coins_view_car.layer.cornerRadius = 10.0
        coins_view_car.layer.borderWidth = 2.0
        coins_view_car.layer.borderColor = UIColor.gray.cgColor
        coins_view_car.clipsToBounds = false
        coins_view_car.layer.shadowOpacity=0.5
        coins_view_car.layer.shadowOffset = CGSize(width: 0, height: 0)
        coins_view_car.layer.shadowColor = UIColor.black.cgColor
        
        
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
