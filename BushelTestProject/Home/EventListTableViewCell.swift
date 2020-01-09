//
//  EventListTableViewCell.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/9/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import UIKit

class EventListTableViewCell: UITableViewCell {
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
