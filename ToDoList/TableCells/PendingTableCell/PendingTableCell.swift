//
//  PendingTableCell.swift
//  ToDoList
//
//  Created by Ishaq Shafiq on 11/09/2017.
//  Copyright © 2017 Ishaq Shafiq. All rights reserved.
//

import UIKit

class PendingTableCell: UITableViewCell {

    @IBOutlet var taskName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
