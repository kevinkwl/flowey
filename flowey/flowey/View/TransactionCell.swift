//
//  TransactionCell.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/28.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabelView: UILabel!
    @IBOutlet weak var dateLabelView: UILabel!
    @IBOutlet weak var amountLabelView: UILabel!

    var transaction: Transaction? {
        didSet {
            let cid = transaction?.category ?? categories.count - 1
            categoryImageView.image = transactionCategoryIcon[cid]
            categoryLabelView.text = categories[cid]
            dateLabelView.text = transaction?.date
            if categories[cid] == "Borrowing" {
                amountLabelView.textColor = Colorify.Nephritis
                amountLabelView.text = "+ \(transaction?.amount ?? 0)"
            } else {
                amountLabelView.textColor = Colorify.DeepOrange
                amountLabelView.text = "- \(transaction?.amount ?? 0)"
            }
            self.contentView.backgroundColor = transactionCategoryBC[cid]
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
