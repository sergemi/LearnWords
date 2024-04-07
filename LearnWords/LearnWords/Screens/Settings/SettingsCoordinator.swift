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
    
    func selectModule()
    func addModule()
    func editModule(_ module: ModelModule)
    func addTopic(module: ModelModule)
    func editTopic(module: ModelModule, topic: ModelTopic)
    func EditWord(topic: ModelTopic)
    func editWord(topic: ModelTopic, learnedWord: ModelLearnedWord)
}

class SettingsCoordinator: CoordinatorProtocol, SettingsCoordinatorProtocol {
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
        
        let vc = SettingsMainMenuViewController.loadFromNib()
        vc.settingsCoordinator = self
//        navigationController.setViewControllers([vc], animated: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func selectModule() {
        let model = EditModuleListMiewModel()
        model.settingsCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addModule() {
        let model = EditModuleViewModel()
        model.settingsCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editModule(_ module: ModelModule) {
        let model = EditModuleViewModel(module: module)
        model.settingsCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addTopic(module: ModelModule) {
        let model = EditTopicViewModel(module: module)
        model.settingsCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editTopic(module: ModelModule, topic: ModelTopic) {
        let model = EditTopicViewModel(module: module, topic: topic)
        model.settingsCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func EditWord(topic: ModelTopic) {
        let model = EditWordViewModel(topic: topic)
        model.settingsCoordinator = self
        let vc =  EditWordViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editWord(topic: ModelTopic, learnedWord: ModelLearnedWord) {
        let model = EditWordViewModel(topic: topic, learnedWord: learnedWord)
        model.settingsCoordinator = self
        let vc =  EditWordViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
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
