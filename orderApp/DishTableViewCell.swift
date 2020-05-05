//
//  DishTableViewCell.swift
//  orderApp
//
//  Created by chenqiming on 2020/4/29.
//  Copyright © 2020 chenqiming. All rights reserved.
//

import UIKit

class DishTableViewCell: UITableViewCell {

    
    @IBOutlet weak var DishNamelbl: UILabel!
    
    
    @IBOutlet weak var DishPricelbl: UILabel!
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
