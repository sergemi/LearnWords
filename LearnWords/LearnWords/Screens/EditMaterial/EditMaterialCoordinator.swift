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
    func editModule(_ module: ModelModule)
    func addTopic(module: ModelModule)
    func editTopic(module: ModelModule, topic: ModelTopic)
    func EditWord(topic: ModelTopic)
    func editWord(topic: ModelTopic, learnedWord: ModelLearnedWord)
}

class EditMaterialCoordinator: CoordinatorProtocol, EditMaterialCoordinatorProtocol {
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    var currentViewController: UIViewController?
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
        let model = EditModuleListMiewModel()
        model.coordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addModule() {
        let model = EditModuleViewModel()
        model.coordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editModule(_ module: ModelModule) {
        let model = EditModuleViewModel(module: module)
        model.coordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addTopic(module: ModelModule) {
        let model = EditTopicViewModel(module: module)
        model.coordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editTopic(module: ModelModule, topic: ModelTopic) {
        let model = EditTopicViewModel(module: module, topic: topic)
        model.coordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func EditWord(topic: ModelTopic) {
        let model = EditWordViewModel(topic: topic)
        model.coordinator = self
        let vc =  EditWordViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editWord(topic: ModelTopic, learnedWord: ModelLearnedWord) {
        let model = EditWordViewModel(topic: topic, learnedWord: learnedWord)
        model.coordinator = self
        let vc =  EditWordViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
