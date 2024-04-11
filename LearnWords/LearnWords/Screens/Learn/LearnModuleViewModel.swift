//
//  LearnModuleViewModel.swift
//  LearnWords
//
//  Created by sergemi on 22.02.2023.
//

import Foundation
import RealmSwift

class LearnModuleViewModel: UniversalTableViewModel {
    var learnCoordinator: LearnCoordinatorProtocol? = nil
    
    var module: ModelModule_realm
    var topics: [ModelTopic_realm] = []
    
    init(module: ModelModule_realm) {
        self.module = module
        super.init()
        
        title.accept(self.module.name)
        tableHeader.accept("Learn.Module.tableHeader".localized())
        
        name.accept(module.name)
        details.accept(module.details)
        
        canSelect.accept(true)
    }
    
    override func reloadTableData(){
//        let realm = try! Realm()
        topics = Array(module.topics)
        
        let topicsRows = topics.map{
            ModelTableViewCell(checkbox: .empty, title: $0.name, showArrow: true)
        }
        rows.accept(topicsRows)
    }
    
    override func selectRow(index: Int) {
        let topic = topics[index]
        self.learnCoordinator?.topic(topic)
    }
}
