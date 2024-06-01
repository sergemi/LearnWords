//
//  EditMaterialCoordinator.swift
//  LearnWords
//
//  Created by sergemi on 07.04.2024.
//

import UIKit

protocol EditMaterialCoordinatorProtocol: AnyObject {
    func selectModule()
    func addModule()
    func editModule(_ id: String)
    func addTopic(moduleId: String)
    func editTopic(moduleId: String, topicId: String)
    func addWord(topicId: String)
    func editWord(topicId: String, learnedWord: LearnedWord)
}

final class EditMaterialCoordinator: CoordinatorProtocol, EditMaterialCoordinatorProtocol {
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    var currentViewController: UIViewController?
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
        
//        dataManager = MockDataManager.instance
        dataManager = Config.instance.dataManager
    }
    
    // - MARK: CoordinatorProtocol
    func start() {
        if started {
            return // TODO: Check if coorrect
        }
        started = true
        log.method()
        selectModule()
    }
    
    // - MARK: EditMaterialCoordinatorProtocol
    func selectModule() {
        let model = EditModuleListViewModel(dataManager: dataManager, coordinator: self)
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addModule() {
        let model = EditModuleViewModel(dataManager: dataManager, coordinator: self)
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editModule(_ id: String) {
        let model = EditModuleViewModel(dataManager: dataManager, coordinator: self, moduleId: id)
        let vc = UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addTopic(moduleId: String) {
        let model = EditTopicViewModel(dataManager: dataManager, coordinator: self, moduleId: moduleId)
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editTopic(moduleId: String, topicId: String) {
        let model = EditTopicViewModel(dataManager: dataManager, coordinator: self, moduleId: moduleId, topicId: topicId)
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addWord(topicId: String) {
        let model = EditWordViewModel(dataManager: dataManager, coordinator: self, topicId: topicId)
        let vc =  EditWordViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editWord(topicId: String, learnedWord: LearnedWord) {
        let model = EditWordViewModel(dataManager: dataManager, coordinator: self, topicId: topicId, learnedWord: learnedWord)
        let vc =  EditWordViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
