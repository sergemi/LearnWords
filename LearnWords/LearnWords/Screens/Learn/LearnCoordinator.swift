//
//  LearnCoordinator.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

//import Foundation
import UIKit

protocol LearnCoordinatorProtocol: AnyObject {
    func BaseLearn()
    func selectModule()
    func module(_ module: Module)
    func topic(_ topic: Topic)
    
    
    func test() // todo: remove
}

class LearnCoordinator: CoordinatorProtocol, LearnCoordinatorProtocol {
    var currentViewController: UIViewController?
    
    var childCoordinators: [CoordinatorProtocol] = []
    weak var parent: CoordinatorProtocol? = nil
    unowned let navigationController:UINavigationController
    var strongNavigationController:UINavigationController? = nil
    var startViewController: UIViewController? = nil
    
    private var started = false
    
    let dataManager: DataManager!

    required init(navigationController: UINavigationController, dataManager: DataManager) {
        log.method()
        
        self.navigationController = navigationController
        self.dataManager = dataManager
    }
    
    required init() {
        log.method()
        
        let nc = UINavigationController()
        self.strongNavigationController = nc
        self.navigationController = nc
//        self.dataManager = MockDataManager.instance
        self.dataManager = Config.instance.dataManager
    }
    
    // MARK: - LearnCoordinatorProtocol
    func BaseLearn() {
        log.method()
        
        let vc = BaseLearnViewController.loadFromNib()
        vc.learnCoordinator = self
//        navigationController.setViewControllers([vc], animated: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func selectModule() {
        let model = LearnModulesListViewModel(dataManager: dataManager)
        model.learnCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func module(_ module: Module) {
        let model = LearnModuleViewModel(dataManager: dataManager, module: module)
        model.learnCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func topic(_ topic: Topic) {
        let model = LearnTopicViewModel(dataManager: dataManager, topic: topic)
        model.learnCoordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func test() { // todo: remove
        let settingsCoordinator = SettingsCoordinator(navigationController: self.navigationController)
        start(coordinator: settingsCoordinator)
    }
 
    // MARK: - CoordinatorProtocol
    
    func start() {
        if started {
            return // TODO: Check if coorrect
        }
        started = true
        log.method()
        
        BaseLearn()
    }
}
