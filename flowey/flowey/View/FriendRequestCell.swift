//
//  FriendRequestCell.swift
//  flowey
//
//  Created by Zefeng Liu on 11/27/18.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

protocol FriendRequestCellDelegate: class {
    func accept(cell: FriendRequestCell)
}

class FriendRequestCell: UITableViewCell {

    @IBOutlet weak var usernameLabelView: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    weak var cellDelegate: FriendRequestCellDelegate?
    
    @IBAction func btnTapped(_ sender: UIButton) {
        cellDelegate?.accept(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        acceptButton.cornerRadius = acceptButton.bounds.height / 2
        acceptButton.backgroundColor = Colorify.Emerald
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
