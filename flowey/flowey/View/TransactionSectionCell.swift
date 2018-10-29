//
//  TransactionSectionCell.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/28.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class TransactionSectionCell: UITableViewCell {
    var isExpanded: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func flip() {
        isExpanded = !isExpanded
    }
}
