//
//  Friend.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/11/26.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import Foundation

struct Friend: Codable {
    let username: String
    let user_id: Int
    
    let flows: [Transaction]
}
