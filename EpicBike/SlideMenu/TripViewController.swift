//
//  TripViewController.swift
//  EpicBike
//
//  Created by Apple on 13/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class TripViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TripTableViewCell
        cell.trip_1.text="data1"
        cell.trip_2.text="data2"
        cell.trip_3.text="data3"
        cell.trip_4.text="data4"

        
        
        return cell
        
    }
    

    
    
    @IBOutlet weak var trip_table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        trip_table.delegate=self
        trip_table.dataSource=self
        
        
        
        
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
