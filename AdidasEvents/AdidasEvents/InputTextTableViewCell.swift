//
//  InputTextTableViewCell.swift
//  AdidasEvents
//
//  Created by Alberto Velaz Moliner on 16/10/2016.
//  Copyright © 2016 Alberto. All rights reserved.
//

import UIKit

class InputTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
