//
//  LearnModulesListViewModel.swift
//  LearnWords
//
//  Created by sergemi on 22.02.2023.
//

import Foundation
import RealmSwift

class LearnModulesListViewModel: UniversalTableViewModel {
    var learnCoordinator: LearnCoordinatorProtocol? = nil
    var modules: [ModelModule] = []
    
    override init() {
        log.method()
        super.init()
        
        title.accept("Learn.ModulesList.Title".localized())
        
        canSelect.accept(true)
    }
    
    override func reloadTableData(){
        let realm = try! Realm()
        modules = Array(realm.objects(ModelModule.self))
        
        let modulesRows = modules.map{
            ModelTableViewCell(checkbox: .hiden, title: $0.name, showArrow: true)
        }
        rows.accept(modulesRows)
    }
    
    override func selectRow(index: Int) {
        let module = modules[index]
        self.learnCoordinator?.module(module)
    }
}
