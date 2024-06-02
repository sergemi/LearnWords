//
//  SettingsCoordinator.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

//import Foundation
import UIKit

protocol SettingsCoordinatorProtocol: AnyObject {
    func mainMenu()
    func editMaterial()
}

final class SettingsCoordinator: CoordinatorProtocol, SettingsCoordinatorProtocol {
    var currentViewController: UIViewController?
    
    var childCoordinators: [CoordinatorProtocol] = []
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
    
    // MARK: - SettingsCoordinatorProtocol
    func mainMenu() {
        log.method()
        
        let model = SettingsMainMenuViewModel(coordinator: self)
        let vc = SettingsMainMenuViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editMaterial() {
        let dataManager = Config.instance.dataManager
        let editMaterialCoordinator = EditMaterialCoordinator(navigationController: navigationController,
                                                              dataManager: dataManager
        )
        start(coordinator: editMaterialCoordinator)
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
}
