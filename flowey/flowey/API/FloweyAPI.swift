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

struct LoginResponse: Codable {
    let jwt_token: String?
}

class _FloweyAPI: Service {
    init() {
        super.init(baseURL: Constants.APIBaseURL, standardTransformers: [.text, .image])
        SiestaLog.Category.enabled = .all
        
        configure("**", description: "jwt token") {
            $0.headers["Authorization"] = " Bearer \(self.authToken ?? "")" // use FakeToken here to bypass auth
            print($0)
        }
        
        let jsonDecoder = JSONDecoder()
        
        configureTransformer("/auth/login", requestMethods: [.post]) {
            try jsonDecoder.decode(LoginResponse.self, from: $0.content)
        }
        
        configureTransformer("/transactions", requestMethods: [.get]) {
            try jsonDecoder.decode([Transaction].self, from: $0.content)
        }
        
        configureTransformer("/friends", requestMethods: [.get]) {
            try jsonDecoder.decode([Friend].self, from: $0.content)
        }
        
        configureTransformer("/friends/request", requestMethods: [.get]) {
            try jsonDecoder.decode([FriendRequest].self, from: $0.content)
        }
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
                guard let json: LoginResponse = entity.typedContent() else {
                    onFailure("JSON parsing error")
                    return
                }
                print(json)
                guard let token = json.jwt_token else {
                    onFailure("JWT token missing")
                    return
                }
                
                self.authToken = token
                print("saved token: \(self.authToken ?? "")")
                onSuccess()
            }
            .onFailure { (error) in
                onFailure(error.userMessage)
        }
        
//        self.resource("/transactions/a").request(.get)
//            .onSuccess {
//                entity in
//                print(entity)
//        }
//            .onFailure {
//                (error) in
//                print(error.userMessage)
//        }
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

    /*
     
        Transactions
     
    */
    var transactions: Resource {
        return self.resource("/transactions")
    }
    
    func addNewTransaction(_ transDict: [String: Any], onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.transactions
            .request(.post, json: transDict)
            .onSuccess { entity in
                onSuccess()
            }
            .onFailure { (error) in
                print(error.userMessage)
                onFailure(error.userMessage)
        }
    }
    
    func updateTransaction(_ tid: Int, transDict: [String: Any], onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.transactions.child("/\(tid)")
            .request(.put, json: transDict)
            .onSuccess { entity in
                onSuccess()
            }
            .onFailure { (error) in
                print(error.userMessage)
                onFailure(error.userMessage)
            }
    }
    
    func deleteTransaction(_ tid: Int, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.transactions.child("/\(tid)")
            .request(.delete)
            .onSuccess { entity in
                print("success delete \(tid)")
                onSuccess()
            }
            .onFailure { error in
                print(error.userMessage)
                onFailure(error.userMessage)
            }
    }
    
    /*
        Friends
    */
    var friends: Resource {
        return self.resource("/friends")
    }
    
    func removeFriend(_ friend_id: Int, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.friends.child("/\(friend_id)")
            .request(.delete)
            .onSuccess { entity in
                print("success delete \(friend_id)")
                onSuccess()
            }
            .onFailure { error in
                print(error.userMessage)
                onFailure(error.userMessage)
        }
    }
    
    func friendRequest(_ email: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.friends.child("/request")
            .request(.post, json: ["email": email])
            .onSuccess { entity in
                print("friend request sent to user with email address \(email)")
                onSuccess()
            }
            .onFailure { error in
                print(error.userMessage)
                onFailure(error.userMessage)
        }
    }
    
    var friend_requests: Resource {
        return self.resource("/friends/request")
    }
    
    func respondToFriendRequest(_ from_user: Int, action: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.friends.child("/request")
            .request(.put, json: ["friend_id": from_user, "action": action])
            .onSuccess { entity in
                onSuccess()
            }
            .onFailure { error in
                print(error.userMessage)
                onFailure(error.userMessage)
        }
    }
    
    func agreeFriendRequest(_ from_user: Int, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.respondToFriendRequest(from_user, action: "agree", onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func rejectFriendRequest(_ from_user: Int, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.respondToFriendRequest(from_user, action: "reject", onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func addNewFriend(_ friendDict: [String: Any], onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        self.resource("/friends/request")
            .request(.post, json: friendDict)
            .onSuccess { entity in
                onSuccess()
            }
            .onFailure { (error) in
                print(error.userMessage)
                onFailure(error.userMessage)
            }
    }
    
}
