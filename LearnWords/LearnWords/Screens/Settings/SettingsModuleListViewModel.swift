//
//  SettingsModuleListViewModel.swift
//  LearnWords
//
//  Created by sergemi on 19.02.2023.
//

import Foundation
import RealmSwift

class SettingsModuleListViewModel: UniversalTableViewModel {
    var settingsCoordinator: SettingsCoordinatorProtocol? = nil
    var modules: [ModelModule] = []
    
    override init() {
        log.method()
        super.init()
        bind()
        
        deleteLineAlertTitle = "Settings.ModulesList.DeleteTableLine.Title".localized()
        deleteLineAlertMessage = "Settings.ModulesList.DeleteTableLine.Message".localized()
        
        title.accept("Settings.ModulesList.Title".localized())
        
//        namePlaceholder.accept("Module Name")
        
//        details.accept("SettingsModuleListViewModel details\n test test test\ntest")
//        details.accept(nil)
//        tableHeader.accept(nil)
        rightBarBtnCaption.accept("Settings.ModulesList.addBtn".localized())
//        tableHeader.accept("Header")
//        hasActionAllBtn.accept(true)
        haveRightBarBtn.accept(true)
//        canEdit.accept(true)
        canSelect.accept(true)
        
//        let testRows: [ModelTableViewCell] = [
//            ModelTableViewCell(checkbox: .hiden, title: "title one", showArrow: true),
//            ModelTableViewCell(checkbox: .empty, title: "title two", percent: 20, showArrow: true),
//            ModelTableViewCell(checkbox: .checked, title: "title three", showArrow: true),
//            ModelTableViewCell(checkbox: .hiden, title: "title four", showArrow: true)
//        ]
//        rows.accept(testRows)
    }
    
    fileprivate func bind() {
        _ = addBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.settingsCoordinator?.addModule()
        }).disposed(by: disposeBag)
    }
    
    override func reloadTableData(){
        let realm = try! Realm()
        modules = Array(realm.objects(ModelModule.self))
        
        let modulesRows = modules.map{
//            ModelTableViewCell(checkbox: .hiden, title: $0.name, showArrow: true)
            ModelTableViewCell(checkbox: .empty, title: $0.name, showArrow: true)
        }
        rows.accept(modulesRows)
    }
    
    override func selectRow(index: Int) {
        let module = modules[index]
        self.settingsCoordinator?.editModule(module)
    }
    
    override func deleteRow(index: Int) {
        log.method()
        
        let moduleToDelete = modules[index]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(moduleToDelete)
        }
        reloadTableData()
    }
}
