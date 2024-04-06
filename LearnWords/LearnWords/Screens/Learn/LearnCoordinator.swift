//
//  LearnCoordinator.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

//import Foundation
import UIKit

protocol LearnCoordinatorProtocol: AnyObject {
    @discardableResult func BaseLearn() -> UIViewController?
    @discardableResult func selectModule() -> UIViewController?
    @discardableResult func module(_ module: ModelModule) -> UIViewController?
    @discardableResult func topic(_ topic: ModelTopic) -> UIViewController?
    
    
    @discardableResult func test() -> UIViewController? // todo: remove
}

class LearnCoordinator: CoordinatorProtocol, LearnCoordinatorProtocol {
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
    
    // MARK: - LearnCoordinatorProtocol
    @discardableResult func BaseLearn() -> UIViewController? {
        log.method()
        
        let vc = BaseLearnViewController.loadFromNib()
        vc.learnCoordinator = self
//        navigationController.setViewControllers([vc], animated: true)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func selectModule() -> UIViewController? {
        let model = LearnModulesListViewModel()
        model.learnCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func module(_ module: ModelModule) -> UIViewController? {
        let model = LearnModuleViewModel(module: module)
        model.learnCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func topic(_ topic: ModelTopic) -> UIViewController? {
        let model = LearnTopicViewModel(topic: topic)
        model.learnCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func test() -> UIViewController? { // todo: remove
        let settingsCoordinator = SettingsCoordinator(navigationController: self.navigationController)
        return start(coordinator: settingsCoordinator)
    }
 
    // MARK: - CoordinatorProtocol
    
    @discardableResult func start() -> UIViewController? {
        if started {
            return nil // TODO: Check if coorrect
        }
        started = true
        log.method()
        
        return BaseLearn()
    }
    
    func setAsRootViewController() {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navigationController)
    }
}
