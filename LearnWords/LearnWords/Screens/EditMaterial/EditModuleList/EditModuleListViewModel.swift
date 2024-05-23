//
//  EditModuleListViewModel.swift
//  LearnWords
//
//  Created by sergemi on 19.02.2023.
//

import Foundation

class EditModuleListViewModel: UniversalTableViewModel {
    var coordinator: EditMaterialCoordinatorProtocol? = nil
    var modules: [Module] = []
    
    let dataManager: DataManager!
    
    init(dataManager: DataManager) {
        log.method()
        
        self.dataManager = dataManager
        super.init()
        
        bind()
        
        deleteLineAlertTitle = "Settings.ModulesList.DeleteTableLine.Title".localized()
        deleteLineAlertMessage = "Settings.ModulesList.DeleteTableLine.Message".localized()
        
        title.accept("Settings.ModulesList.Title".localized())
        
        haveRightBarBtn.accept(true)
        canDeleteRows.accept(true)
        canSelect.accept(true)
    }
    
    fileprivate func bind() {
        _ = rightBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.coordinator?.addModule()
        }).disposed(by: disposeBag)
    }
    
    override func reloadTableData(){
        return // TODO:
//        modules = dataManager.modules
//        
//        let modulesRows = modules.map{
//            ModelTableViewCell(checkbox: .empty,
//                               title: $0.name,
//                               showArrow: true
//            )
//        }
//        
//        rows.accept(modulesRows)
    }
    
    override func selectRow(index: Int) {
        let module = modules[index]
        self.coordinator?.editModule(module)
    }
    
    override func deleteRow(index: Int) {
        log.method()
        let module = modules[index]
        if dataManager.deleteModule(module) == nil {
            print("error deleting module")
            return
        }        
        reloadTableData()
    }
}
