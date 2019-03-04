//
//  SwitchLocationViewController.swift
//  EpicBike
//
//  Created by Apple on 14/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class SwitchLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let cellSpacingHeight: CGFloat = 20

    @IBOutlet weak var locationTable: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sl", for: indexPath as IndexPath) as! SwitchLocationTableViewCell
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.clipsToBounds = false
        cell.layer.shadowOpacity=0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.loc_name.text="Location \(indexPath)"
        
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        locationTable.delegate=self
        locationTable.dataSource=self
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
