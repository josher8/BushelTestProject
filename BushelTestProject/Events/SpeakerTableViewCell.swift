//
//  SpeakerTableViewCell.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/10/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import UIKit

class SpeakerTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
