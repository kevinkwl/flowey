//
//  Constants.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/25.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import Foundation

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
