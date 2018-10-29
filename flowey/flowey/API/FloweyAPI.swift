//
//  FloweyAPI.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/25.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import Foundation
import Siesta

let FloweyAPI = _FloweyAPI()
class _FloweyAPI: Service {
    init() {
        super.init(baseURL: Constants.APIBaseURL)
        
        configure { $0.headers[Constants.JWT_Token_Key] = self.authToken }
    }
    
    var authToken: String? {
        didSet {
            wipeResources()
            invalidateConfiguration()
        }
    }
    
    func login(_ email: String, _ password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.resource("/auth/login")
            .request(.post, json: ["email": email, "password": password])
            .onSuccess { entity in
                guard let json: [String: Any] = entity.typedContent() else {
                    onFailure("JSON parsing error")
                    return
                }
                print(json)
                guard let token = json[Constants.JWT_Token_Key] else {
                    onFailure("JWT token missing")
                    return
                }
                
                self.authToken = token as? String
                
                onSuccess()
            }
            .onFailure { (error) in
                onFailure(error.userMessage)
        }
    }
    
    func register(_ email: String, _ password: String, _ username: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.resource("/auth/register")
            .request(.post, json: ["email": email, "password": password, "username": username])
            .onSuccess { entity in
//                guard let json: [String: String] = entity.typedContent() else {
//                    onFailure("JSON parsing error")
//                    return
//                }
                onSuccess()
            }
            .onFailure { (error) in
                onFailure(error.userMessage)
        }
    }
}
