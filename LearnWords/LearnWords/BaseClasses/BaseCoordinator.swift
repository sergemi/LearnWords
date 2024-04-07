//
//  BaseCoordinator.swift
//  LearnWords
//
//  Created by sergemi on 09.02.2021.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol CoordinatorProtocol: AnyObject {
    init()
    init(navigationController:UINavigationController, strongNC:Bool)
    
    var currentViewController: UIViewController? {get}
    
    var childCoordinators: [CoordinatorProtocol] { get set }
    var parent: CoordinatorProtocol? {get set}
    var startViewController: UIViewController? {get set}
    var navigationController: UINavigationController {get}
    
//    var id: Int {get}
    
    func start()
    func start(coordinator: CoordinatorProtocol)
    func returnToParrent()
    
//    func removeCoordinator(_ coordinator: CoordinatorProtocol)
    
}

extension CoordinatorProtocol {
    func popToStartViewController () {
        log.method()
        
        guard let startViewController = startViewController else {
            return
        }
        navigationController.popToViewController(startViewController, animated: true) // maybe don't need
        navigationController.dismiss(animated: true)
    }
    
    func returnToParrent() {
        log.method()
        
        guard let startViewController = startViewController else {
            return
        }
        navigationController.popToViewController(startViewController, animated: true) // maybe don't need
        navigationController.dismiss(animated: true)
        
        removeFromParent()
    }
    
    func start(coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
        coordinator.parent = self
        coordinator.startViewController = self.currentViewController
        coordinator.start()
    }
    
    func removeCoordinator(_ coordinator: CoordinatorProtocol) {
        guard !childCoordinators.isEmpty else {
            return
        }
        
        var index = childCoordinators.count - 1
        for curCoordinator in childCoordinators.reversed() {
            if coordinator === curCoordinator {
                childCoordinators.remove(at: index)
                break
            }
            index = index-1
        }
    }
    
    func removeFromParent() {
        parent?.removeCoordinator(self)
    }
}

//extension CoordinatorProtocol {
//    func forceLogin() {
//        log.method()
//
//        let authCoordinator = AuthCoordinator(navigationController: navigationController)
//        start(coordinator: authCoordinator)
//    }
//}

