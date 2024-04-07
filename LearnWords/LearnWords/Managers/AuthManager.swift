//
//  AuthManager.swift
//  LearnWords
//
//  Created by sergemi on 07.04.2024.
//

import UIKit
import FirebaseAuth

class AuthManager {
    weak var coordinator: CoordinatorProtocol?
    var handle: AuthStateDidChangeListenerHandle?
    
    init(coordinator: CoordinatorProtocol?) {
        self.coordinator = coordinator
        
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let coordinator = self?.coordinator else {
                return
            }
            if user == nil {
                print("-- USER NOT LOGINED !!!")
                
                coordinator.start(coordinator: AuthenticateCoordinator(navigationController: coordinator.navigationController))
            }
            else {
                print("++ USER LOGINED !!!")
                
            }
        }
    }
    
    typealias LoginCompletionBlock = (AuthDataResult?, Error?) -> Void
    
    class func login(email: String, password: String, withCompletion completion: LoginCompletionBlock? = nil) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // FIRAuthDataResult?
            // Error?
            completion?(authResult, error)
        }
    }
    
    class func logOut() {
        do {
          try Auth.auth().signOut()
        } catch let error {
          print("Auth sign out failed: \(error)")
        }
    }
}

