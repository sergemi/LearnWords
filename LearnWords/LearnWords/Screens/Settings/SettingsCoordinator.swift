//
//  SettingsCoordinator.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

//import Foundation
import UIKit

protocol SettingsCoordinatorProtocl: AnyObject {
    func mainMenu()
}

class SettingsCoordinator: CoordinatorProtocol, SettingsCoordinatorProtocl {
    var currentViewController: UIViewController?
    
    var childCoordinators: [CoordinatorProtocol] = []
    weak var parent: CoordinatorProtocol? = nil
    unowned let navigationController:UINavigationController
    var strongNavigationController:UINavigationController? = nil
    var startViewController: UIViewController? = nil
    
    private var started = false

    required init(navigationController: UINavigationController, strongNC:Bool = false) {
        log.method()
        
        self.navigationController = navigationController
    }
    
    required init() {
        log.method()
        
        let nc = UINavigationController()
        self.strongNavigationController = nc
        self.navigationController = nc
    }
    
    // MARK: - SettingsCoordinatorProtocl
    func mainMenu() {
        log.method()
        
        let vc = SettingsMainMenuViewController.loadFromNib()
        vc.settingsCoordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }
 
    // MARK: - CoordinatorProtocol
    
    func start() {
        if started {
            return
        }
        started = true
        log.method()
        
        mainMenu()
    }
    
    func setAsRootViewController() {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navigationController)
    }
}
