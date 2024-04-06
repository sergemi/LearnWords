//
//  AuthenticateCoordinator.swift
//  LearnWords
//
//  Created by sergemi on 05.04.2024.
//

import UIKit

protocol AuthenticateProtocol: AnyObject {
    @discardableResult func Login() -> UIViewController?
}

class AuthenticateCoordinator: CoordinatorProtocol, AuthenticateProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    
    var currentViewController: UIViewController?
    weak var parent: CoordinatorProtocol? = nil
    
    unowned let navigationController:UINavigationController
    var strongNavigationController:UINavigationController? = nil
    var startViewController: UIViewController? = nil
    
    private var started = false
    
    required init(navigationController: UINavigationController, strongNC: Bool) {
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
    @discardableResult func Login() -> UIViewController? {
        let vc = LoginViewController.loadFromNib()
        vc.authenticateCoordinator = self
        navigationController.pushViewController(vc, animated: true)
        currentViewController = vc
        
        return vc
    }
    
    // - MARK: CoordinatorProtocol
    
    @discardableResult func start() -> UIViewController? {
        if started {
            return nil // TODO: Check if coorrect
        }
        started = true
        log.method()
        
        return Login()
    }
}
