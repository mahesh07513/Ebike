//
//  TripTableViewCell.swift
//  EpicBike
//
//  Created by Apple on 13/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet weak var trip_1: UILabel!
    
    @IBOutlet weak var trip_2: UILabel!
    
    
    @IBOutlet weak var trip_3: UILabel!
    
    
    @IBOutlet weak var trip_4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
