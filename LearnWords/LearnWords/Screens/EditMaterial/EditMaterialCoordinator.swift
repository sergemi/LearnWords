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
    func addTopic(module: Module)
    func editTopic(module: Module, topic: Topic)
    func editWord(topic: Topic)
    func editWord(topic: Topic, learnedWord: LearnedWord)
}

class EditMaterialCoordinator: CoordinatorProtocol, EditMaterialCoordinatorProtocol {
    
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
        let model = EditModuleListViewModel(dataManager: dataManager)
        model.coordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addModule() {
        let model = EditModuleViewModel(dataManager: dataManager)
        model.coordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editModule(_ id: String) {
        Task {
            do {
                let module = try await dataManager.module(id: id)
                let model = EditModuleViewModel(dataManager: dataManager, module: module)
                model.coordinator = self
                let vc =  await UniversalTableViewController(viewModel: model)
                await navigationController.pushViewController(vc, animated: true)
                
            } catch {
                if let error = error as? LocalizedError {
                    print(error.localizedDescription)
                } else {
                    print("An unexpected error occurred: \(error)")
                }
            }
        }
        
//        let model = EditModuleViewModel(dataManager: dataManager, module: module)
//        model.coordinator = self
//        let vc =  UniversalTableViewController(viewModel: model)
//        navigationController.pushViewController(vc, animated: true)
    }
    
    func addTopic(module: Module) {
        let model = EditTopicViewModel(dataManager: dataManager, module: module)
        model.coordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editTopic(module: Module, topic: Topic) {
        let model = EditTopicViewModel(dataManager: dataManager, module: module, topic: topic)
        model.coordinator = self
        let vc =  UniversalTableViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editWord(topic: Topic) {
        let model = EditWordViewModel(dataManager: dataManager, topic: topic)
        model.coordinator = self
        let vc =  EditWordViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editWord(topic: Topic, learnedWord: LearnedWord) {
        let model = EditWordViewModel(dataManager: dataManager, topic: topic, learnedWord: learnedWord)
        model.coordinator = self
        let vc =  EditWordViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
