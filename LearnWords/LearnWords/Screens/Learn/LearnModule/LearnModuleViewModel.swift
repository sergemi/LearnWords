//
//  LearnModuleViewModel.swift
//  LearnWords
//
//  Created by sergemi on 22.02.2023.
//

import Foundation

class LearnModuleViewModel: UniversalTableViewModel {
    var learnCoordinator: LearnCoordinatorProtocol? = nil
    private let dataManager: DataManager!
    
    var moduleId: String
    var module: Module?
    var topics: [Topic] = []
    
    init(dataManager: DataManager, moduleId: String) {
        self.dataManager = dataManager
        self.moduleId = moduleId
        super.init()
        
        tableHeader.accept("Learn.Module.tableHeader".localized())
        
        // todo
//        title.accept(self.module.name)
//        name.accept(module.name)
//        details.accept(module.details)
        
        canSelect.accept(true)
    }
    
    override func reloadData(){
        // TODO
//        topics = Array(module.topics)
        
        let topicsRows = topics.map{
            ModelTableViewCell(checkbox: .empty, title: $0.name, showArrow: true)
        }
        rows.accept(topicsRows)
    }
    
    override func selectRow(index: Int) {
        // todo
//        let topic = topics[index]
//        self.learnCoordinator?.topic(topic)
    }
}
