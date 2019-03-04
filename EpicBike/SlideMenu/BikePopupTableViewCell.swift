//
//  BikePopupTableViewCell.swift
//  EpicBike
//
//  Created by Apple on 18/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class BikePopupTableViewCell: UITableViewCell {

    @IBOutlet weak var bikeId: UILabel!
    
    
    @IBOutlet weak var bikeRange: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
