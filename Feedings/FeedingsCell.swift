//
//  FeedingsCell.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/28/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit

class FeedingsCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    var feeding: FeedingViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
