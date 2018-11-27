//
//  Constants.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/25.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let APIBaseURL = "http://127.0.0.1:5000"
    
    static let JWT_Token_Key = "jwt_token"
    
    static let hasLoginKey = "isLogin"
    
    struct StoryboardID {
        static let MainID = "MainVC"
        static let RegisterVC = "RegisterVC"
        static let LoginVC = "LoginVC"
    }
}

let categories: [String] = ["Food & Dining", "Travel", "Lend", "Borrow", "MISC", "Return", "Receive"]
let transactionCategoryIcon: [UIImage] = [#imageLiteral(resourceName: "food_dining"), #imageLiteral(resourceName: "travel"), #imageLiteral(resourceName: "lend_borrow"), #imageLiteral(resourceName: "lend_borrow"), #imageLiteral(resourceName: "misc")]
let transactionCategoryBC: [UIColor] = [Colorify.Lime, Colorify.Clouds, Colorify.Sunflower, Colorify.Cyan, Colorify.Yellow]
