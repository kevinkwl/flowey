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
    @IBOutlet weak var amountLabelView: UILabel!
    
    @IBOutlet weak var objectUserView: UIView!
    @IBOutlet weak var objectRelationLabelView: UILabel!
    @IBOutlet weak var objectUserLabelView: UILabel!
    
    var transaction: Transaction? {
        didSet {
            let cid = transaction?.category ?? categories.count - 1
            categoryImageView.image = transactionCategoryIcon[cid]
            categoryLabelView.text = categories[cid]
            amountLabelView.text = getMoneyStr(money: transaction?.amount ?? 0)
            
            if is_flow(cid) {
                objectUserView.isHidden = false
                
                if is_flow_out(cid) {
                    objectRelationLabelView.text = "to"
                } else {
                    objectRelationLabelView.text = "from"
                }
                
                objectUserLabelView.text = transaction?.object_user_name ?? "other people"
                amountLabelView.textColor = Colorify.Steel
            } else {
                objectUserView.isHidden = true
                
                amountLabelView.textColor = Colorify.Grenadine
            }
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
