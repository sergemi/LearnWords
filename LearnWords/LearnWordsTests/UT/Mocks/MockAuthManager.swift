//
//  MockAuthManager.swift
//  LearnWordsTests
//
//  Created by sergemi on 11.04.2024.
//

import Foundation
import FirebaseAuth

@testable import LearnWords

class MockAuthManager: AuthProtocol {
    static func loginGoogle(credential: AuthCredential) async throws {
        fatalError("Not realized")
    }
    
    static var userId: String? = nil
    
    struct MockUser {
        let email: String
        let password: String
    }
    
    static var users: [String: MockUser] = [:]
    
    static func logOut() throws {
        userId = nil
    }
    
    static func login(email: String, password: String) async throws {
        for (key, val) in users {
            if val.email == email && val.password == password {
                userId = key
                return
            }
        }
    }
    
    static func createUser(email: String, password: String) async throws {
        let user = MockUser(email: email, password: password)
        users[email] = user
    }
    
    static func createUserAndLogin(email: String, password: String) async throws {
        try await createUser(email: email, password: password)
        try await login(email: email, password: password)
    }
}
