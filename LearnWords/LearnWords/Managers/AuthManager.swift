//
//  AuthManager.swift
//  LearnWords
//
//  Created by sergemi on 07.04.2024.
//

import UIKit
import FirebaseCore // ?
import FirebaseAuth
import GoogleSignIn // ?

protocol AuthProtocol {
    static var userId: String?  {get}
    
    static func logOut() throws
    
    static func login(email: String, password: String) async throws
    
    static func createUser(email: String, password: String) async throws
    
    static func createUserAndLogin(email: String, password: String) async throws
    
    static func loginGoogle(credential: AuthCredential) async throws
    
    // TODO: implement
//    static func resetPassword(email: String) async throws
    
}

final class AuthManager: AuthProtocol {
    private weak var coordinator: CoordinatorProtocol?
    private var handle: AuthStateDidChangeListenerHandle?
    
    init(coordinator: CoordinatorProtocol?) {
        self.coordinator = coordinator
        
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let coordinator = self?.coordinator else {
                return
            }
            if user == nil {
                print("User is not logged in. Starting authenticate coordinator")
                
                coordinator.start(coordinator: AuthenticateCoordinator(navigationController: coordinator.navigationController))
            }
            else {
                print("User is logged in")
                
            }
        }
    }
    
    static var userId: String? {
        return Auth.auth().currentUser?.uid
    }
        
    static func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
        
    static func createUser(email: String, password: String) async throws {
            try await Auth.auth().createUser(withEmail: email, password: password)
        }
    
    static func createUserAndLogin(email: String, password: String) async throws {
        try await createUser(email: email, password: password)
        try await login(email: email, password: password)
    }
    
    class func logOut() throws {
        try Auth.auth().signOut()
    }
    
    static func loginGoogle(credential: AuthCredential) async throws {
        try await Auth.auth().signIn(with: credential)
    }
    
//    func resetPassword(email: String) async throws {
//        try await Auth.auth().sendPasswordReset(withEmail: email)
//    }
}

