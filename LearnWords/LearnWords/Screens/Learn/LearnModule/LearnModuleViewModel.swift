//
//  LearnModuleViewModel.swift
//  LearnWords
//
//  Created by sergemi on 22.02.2023.
//

import Foundation

final class LearnModuleViewModel: UniversalTableViewModel {
    var learnCoordinator: LearnCoordinatorProtocol? = nil
    private let dataManager: DataManager!
    
    var moduleId: String
    var module: Module?
    
    init(dataManager: DataManager, moduleId: String) {
        self.dataManager = dataManager
        self.moduleId = moduleId
        super.init()
        
        tableHeader.accept("Learn.Module.tableHeader".localized())
        canSelect.accept(true)
    }
    
    override func reloadData(){
        log.method()
        
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.module = try await dataManager.module(id: moduleId) // todo: is it still need?
                guard let module = self.module else {
                    return
                }
                
                let topicsRows = module.topics.map{
                    ModelTableViewCell(checkbox: .empty, title: $0.name, showArrow: true)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.title.accept(module.name)
                    self?.name.accept(module.name)
                    self?.details.accept(module.details)
                    self?.rows.accept(topicsRows)
                }
            }
            catch {
                if let error = error as? LocalizedError {
                    print(error.localizedDescription)
                } else {
                    print("An unexpected error occurred: \(error)")
                }
            }
        }
    }
    
    override func selectRow(index: Int) {
        guard let module = module else {
            return
        }
        let topicId = module.topics[index].id
        learnCoordinator?.topic(topicId)
    }
}
