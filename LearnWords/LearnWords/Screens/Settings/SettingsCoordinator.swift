//
//  SettingsCoordinator.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

//import Foundation
import UIKit

protocol SettingsCoordinatorProtocol: AnyObject {
    @discardableResult func mainMenu() -> UIViewController?
    
    @discardableResult func selectModule() -> UIViewController?
    @discardableResult func addModule() -> UIViewController?
    @discardableResult func editModule(_ module: ModelModule) -> UIViewController?
    @discardableResult func addTopic(module: ModelModule) -> UIViewController?
    @discardableResult func editTopic(module: ModelModule, topic: ModelTopic) -> UIViewController?
    @discardableResult func newWord(topic: ModelTopic) -> UIViewController?
    @discardableResult func editWord(topic: ModelTopic, learnedWord: ModelLearnedWord) -> UIViewController?
}

class SettingsCoordinator: CoordinatorProtocol, SettingsCoordinatorProtocol {
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
    
    // MARK: - SettingsCoordinatorProtocol
    @discardableResult func mainMenu() -> UIViewController? {
        log.method()
        
        let vc = SettingsMainMenuViewController.loadFromNib()
        vc.settingsCoordinator = self
//        navigationController.setViewControllers([vc], animated: true)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func selectModule() -> UIViewController? {
        let model = SettingsModuleListViewModel()
        model.settingsCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func addModule() -> UIViewController? {
        let model = SettingsAddModuleViewModel()
        model.settingsCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func editModule(_ module: ModelModule) -> UIViewController? {
        let model = SettingsAddModuleViewModel(module: module)
        model.settingsCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func addTopic(module: ModelModule) -> UIViewController? {
        let model = SettingsAddTopicViewModel(module: module)
        model.settingsCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func editTopic(module: ModelModule, topic: ModelTopic) -> UIViewController? {
        let model = SettingsAddTopicViewModel(module: module, topic: topic)
        model.settingsCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func newWord(topic: ModelTopic) -> UIViewController? {
        let model = NewWordViewModel(topic: topic)
        model.settingsCoordinator = self
        let vc =  NewWordViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
    
    @discardableResult func editWord(topic: ModelTopic, learnedWord: ModelLearnedWord) -> UIViewController? {
        let model = NewWordViewModel(topic: topic, learnedWord: learnedWord)
        model.settingsCoordinator = self
        let vc =  NewWordViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
 
    // MARK: - CoordinatorProtocol
    
    @discardableResult func start() -> UIViewController? {
        if started {
            return nil
        }
        started = true
        log.method()
        
        return mainMenu()
    }
    
    func setAsRootViewController() {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navigationController)
    }
}
