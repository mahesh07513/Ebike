//
//  SwitchLocationTableViewCell.swift
//  EpicBike
//
//  Created by Apple on 14/02/19.
//  Copyright © 2019 Mahesh. All rights reserved.
//

import UIKit

class SwitchLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var location: UIImageView!
    
    @IBOutlet weak var loc_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
