//
//  MainTabBarCoordinator.swift
//  LearnWord
//
//  Created by sergemi on 11.02.2021.
//

import UIKit
import RxCocoa
import RxSwift

class MainTabBarCoordinator: NSObject, CoordinatorProtocol, UITabBarControllerDelegate {
    var childCoordinators: [CoordinatorProtocol] = []
    weak var parent: CoordinatorProtocol? = nil
    unowned var navigationController:UINavigationController {
        return tabBarController.selectedViewController! as! UINavigationController
    }
    var startViewController: UIViewController? = nil
    
    var currentViewController: UIViewController? {
        return navigationController.viewControllers.last
    }
    
    fileprivate lazy var model = MainTabBarViewModel()
    var tabBarController: UITabBarController = UITabBarController()
    
    fileprivate var coordinators: [CoordinatorProtocol] = []
    
    required init(navigationController: UINavigationController, strongNC:Bool = false) {
        log.method()
        
//        self.navigationController = navigationController
//
//        if strongNC {
//            self.strongNavigationController = navigationController
//        }
    }
    
    
    required override init() {
        log.method()
        
    }
    
    deinit {
        log.method()
    }
    
    func setAsRootViewController() {
        log.method()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
    }
    
    @discardableResult func start() -> UIViewController? {
        log.method()
        
        tabBarController.delegate = self
        
//        setAsRootViewController() // sergemi_temp
        let mySceneDelegate = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)
        mySceneDelegate!.startCoordinator = self
   
        for tab in model.tabs {
            let coordinator = model.getCoordinator(tab)
            coordinators.append(coordinator)
            
            let tabBarItem = UITabBarItem(title: model.getTitle(tab),
                                          image: UIImage(named: model.getIconName(tab)),
                                     tag: tab.rawValue)
            coordinator.navigationController.tabBarItem = tabBarItem
        }
        let navControllers = coordinators.map{$0.navigationController}
        tabBarController.viewControllers = navControllers
        return startSelectedCoordinator()
    }
    
    fileprivate func startCoordinator(index: Int) -> UIViewController? {
        return coordinators[index].start()
    }
    
    fileprivate func startSelectedCoordinator() -> UIViewController? {
        let index = tabBarController.selectedIndex
        return startCoordinator(index: index)
    }
    
    // MARK: UITabBarControllerDelegate
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
////        log.debug("tabBarController.shouldSelect")
//        return true
//    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
//        log.debug("tabBarController.didSelect")
        startSelectedCoordinator()
    }
    
}


