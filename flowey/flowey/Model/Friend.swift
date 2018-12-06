//
//  Friend.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/11/26.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import Foundation

struct Friend: Codable, Hashable, Equatable, CustomStringConvertible {
    
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.user_id == rhs.user_id
    }
    
    let username: String
    let user_id: Int
    
    let flows: [Transaction]
    
    var description: String {
        return username
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(user_id)
    }
}
