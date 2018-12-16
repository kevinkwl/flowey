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
    static let APIBaseURL = "http://192.168.1.34:5000"
    
    static let JWT_Token_Key = "jwt_token"
    
    static let hasLoginKey = "isLogin"
    
    struct StoryboardID {
        static let MainID = "MainVC"
        static let RegisterVC = "RegisterVC"
        static let LoginVC = "LoginVC"
    }
}

let categoryDict: [String: Int] = ["Food & Dining":0, "Travel":1, "Lend":2, "Borrow":3, "Other":4, "Return":5, "Receive":6]
let categories: [String] = ["Food & Dining", "Travel", "Lend", "Borrow", "Other", "Return", "Receive"]
let categories_for_creation = ["Food & Dining", "Travel", "Lend", "Borrow", "Other", "Return"]
let transactionCategoryIcon: [UIImage] = [#imageLiteral(resourceName: "food_dining"), #imageLiteral(resourceName: "travel"), #imageLiteral(resourceName: "lend_borrow"), #imageLiteral(resourceName: "lend_borrow"), #imageLiteral(resourceName: "misc"), #imageLiteral(resourceName: "lend_borrow"), #imageLiteral(resourceName: "lend_borrow")]
let transactionCategoryBC: [UIColor] = [Colorify.Lime, Colorify.Clouds, Colorify.Sunflower, Colorify.Cyan, Colorify.Yellow, Colorify.Sunflower, Colorify.Sunflower]
