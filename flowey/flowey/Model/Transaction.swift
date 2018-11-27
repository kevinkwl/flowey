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
    
    func real_amount() -> Int {
        if categories[category] == "Borrowing" {
            return -1 * amount
        } else {
            return amount
        }
    }
}
