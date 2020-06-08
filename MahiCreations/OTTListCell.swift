//
//  OTTListCell.swift
//  MahiCreations
//
//  Created by k.chinnababu on 07/06/20.
//  Copyright © 2020 Mahi Info services. All rights reserved.
//

import UIKit

class OTTListCell: UITableViewCell {

    @IBOutlet weak var channelTextFieldName: UILabel!
    @IBOutlet weak var endDateTextField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
