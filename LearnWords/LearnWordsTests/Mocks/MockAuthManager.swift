//
//  MockAuthManager.swift
//  LearnWordsTests
//
//  Created by sergemi on 11.04.2024.
//

import Foundation
@testable import LearnWords

class MockAuthManager: AuthProtocol {
    static var userId: String? = nil
    
    struct MockUser {
        let email: String
        let password: String
    }
    
    static var users: [String: MockUser] = [:]
    
    static func logOut() {
        userId = nil
    }
    
    static func login(email: String, password: String, withCompletion completion: AuthCompletionBlock?) {
        for (key, val) in users {
            if val.email == email && val.password == password {
                userId = key
                return
            }
        }
        
    }
    
    static func createUser(email: String, password: String, withCompletion completion: AuthCompletionBlock?) {
        let user = MockUser(email: email, password: password)
        users[email] = user
    }
    
    static func createUserAndLogin(email: String, password: String, withCompletion completion: AuthCompletionBlock?) {
        
        createUser(email: email, password: password) { result, error in
            login(email: email, password: password) { result, error in
                completion?(result, error)
                
            }
        }
    }
    
    
}
