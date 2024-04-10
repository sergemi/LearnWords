//
//  AuthManager.swift
//  LearnWords
//
//  Created by sergemi on 07.04.2024.
//

import UIKit
import FirebaseAuth

protocol AuthProtocol{
    static var userId: String?  {get}
    
    static func logOut()
    
    static func login(email: String, password: String, withCompletion completion: AuthCompletionBlock?)
    
    static func createUser(email: String, password: String, withCompletion completion: AuthCompletionBlock?)
    
    static func createUserAndLogin(email: String, password: String, withCompletion completion: AuthCompletionBlock?)
    
    typealias AuthCompletionBlock = (AuthDataResult?, Error?) -> Void
}

class AuthManager: AuthProtocol {
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
    
    class func login(email: String, password: String, withCompletion completion: AuthCompletionBlock? = nil) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion?(authResult, error)
        }
    }
    
    class func createUser(email: String, password: String, withCompletion completion: AuthCompletionBlock?) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                completion?(authResult, error)
        }
    }
    
    class func createUserAndLogin(email: String, password: String, withCompletion completion: AuthCompletionBlock?) {
        createUser(email: email, password: password) { result, error in
            if error == nil {
                login(email: email, password: password) { result, error in
                    completion?(result, error)
                }
            }
            else {
                completion?(result, error)
            }
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

