//
//  AuthenticateCoordinator.swift
//  LearnWords
//
//  Created by sergemi on 05.04.2024.
//

import UIKit

protocol AuthenticateProtocol: AnyObject {
    func Login()
}

class AuthenticateCoordinator: CoordinatorProtocol, AuthenticateProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    
    var currentViewController: UIViewController?
    weak var parent: CoordinatorProtocol? = nil
    
    unowned let navigationController:UINavigationController
    var strongNavigationController:UINavigationController? = nil
    var startViewController: UIViewController? = nil
    
    private var started = false
    
    required init(navigationController: UINavigationController) {
        log.method()
        
        self.navigationController = navigationController
    }
    
    required init() {
        log.method()
        
        let nc = UINavigationController()
        self.strongNavigationController = nc
        self.navigationController = nc
    }
    
    // - MARK: AuthenticateProtocol
    func Login() {
        let vc = LoginViewController.loadFromNib()
        vc.authenticateCoordinator = self
        navigationController.pushViewController(vc, animated: true)
        currentViewController = vc
    }
    
    // - MARK: CoordinatorProtocol
    
    func start() {
        if started {
            return // TODO: Check if coorrect
        }
        started = true
        log.method()
        Login()
    }
}
