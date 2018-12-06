//
//  FriendCell.swift
//  flowey
//
//  Created by Zefeng Liu on 11/25/18.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var usernameLabelView: UILabel!
    @IBOutlet weak var flowLabelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
