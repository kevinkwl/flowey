//
//  Transaction.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/29.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    let transaction_id: Int
    var amount: Int
    let currency: String
    var category: Int
    var date: String
    let user_id: Int
    var last_modified: String
    var object_user_id: Int?
    var object_user_name: String?
    
    func real_amount() -> Int {
        if categories[category] == "Borrow" || categories[category] == "Receive" {
            return -1 * amount
        } else {
            return amount
        }
    }
    
    func expense_amount() -> Int {
        if is_flow(categories[category]) {
            return 0
        }
        return amount
    }
    
    func flow_amount() -> Int {
        if categories[category] == "Borrow"  || categories[category] == "Receive" {
            return -1 * amount
        } else {
            return amount
        }
    }
}
