//
//  requestTableViewCell.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/24/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit

class requestTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buyingOrSellingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

}
