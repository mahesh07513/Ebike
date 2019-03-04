//
//  BikesPopupViewController.swift
//  EpicBike
//
//  Created by Apple on 18/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class BikesPopupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var fleetName = String()
    @IBOutlet weak var bikesTable: UITableView!
    @IBOutlet weak var popviewVar: UIView!
    let cellSpacingHeight: CGFloat = 20
    
    @IBOutlet weak var fleet_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        fleet_label.text = fleetName
        
        // Do any additional setup after loading the view.
        bikesTable.delegate=self
        bikesTable.dataSource=self
        
        
        //For Auto Resize Table View Cell;
        bikesTable.estimatedRowHeight = 44
        bikesTable.rowHeight = UITableViewAutomaticDimension
        
        //Detault Background clear
        bikesTable.backgroundColor = UIColor.clear
        
    }
    

    @IBAction func bikesClose(_ sender: Any) {
         self.willMove(toParentViewController: nil)
         self.view.removeFromSuperview()
         self.removeFromParentViewController()
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50.0;
//
//    }
//
////    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        cell.contentView.backgroundColor = UIColor.clear
////        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 40))
////        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
////        whiteRoundedView.layer.masksToBounds = false
////        whiteRoundedView.layer.cornerRadius = 3.0
////        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
////        whiteRoundedView.layer.shadowOpacity = 0.5
////        cell.contentView.addSubview(whiteRoundedView)
////        cell.contentView.sendSubview(toBack: whiteRoundedView)
////    }
//
//
//    // Set the spacing between sections
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return cellSpacingHeight
//    }
//
//    // Make the background color show through
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "bikes", for: indexPath as IndexPath) as! BikePopupTableViewCell
//
//        cell.bikeId.text="#1236541"
//        cell.bikeRange.text="20km"
//        cell.layer.cornerRadius = 10.0
//        cell.layer.borderWidth = 2.0
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.clipsToBounds = true
////        cell.layer.shadowOpacity=0.5
////        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
////        cell.layer.shadowColor = UIColor.black.cgColor
//
//
//        return cell
//    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bikes", for: indexPath as IndexPath) as! BikePopupTableViewCell
        cell.bikeId.text = "#123456"
        cell.bikeRange.text="20km"
        
//        //For bottom border to tv_title;
//        let frame =  cell.bik.frame
//        let bottomLayer = CALayer()
//        bottomLayer.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
//        bottomLayer.backgroundColor = UIColor.black.cgColor
//        cell.tv_title.layer.addSublayer(bottomLayer)
        
        //borderColor,borderWidth, cornerRadius
        cell.backgroundColor = UIColor.lightGray
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }

    
}
