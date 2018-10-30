//
//  CircleImageView.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/29.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}
