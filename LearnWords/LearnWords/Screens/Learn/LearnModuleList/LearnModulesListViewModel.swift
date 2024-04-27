//
//  LearnModulesListViewModel.swift
//  LearnWords
//
//  Created by sergemi on 22.02.2023.
//

import Foundation

class LearnModulesListViewModel: UniversalTableViewModel {
    var learnCoordinator: LearnCoordinatorProtocol? = nil
    let dataManager: DataManager!
    var modules: [Module] = []
    
    init(dataManager: DataManager) {
        log.method()
        self.dataManager = dataManager
        super.init()
        
        title.accept("Learn.ModulesList.Title".localized())
        
        canSelect.accept(true)
    }
    
    override func reloadTableData(){
        modules = []//dataManager.modules // todo: sergemi
        
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
