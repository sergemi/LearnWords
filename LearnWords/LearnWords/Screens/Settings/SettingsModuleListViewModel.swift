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
        
        title.accept("Settings.ModulesList.Title".localized())
        
//        namePlaceholder.accept("Module Name")
        
//        details.accept("SettingsModuleListViewModel details\n test test test\ntest")
//        details.accept(nil)
//        tableHeader.accept(nil)
        addBtnCaption.accept("Settings.ModulesList.addBtn".localized())
//        tableHeader.accept("Header")
//        hasActionAllBtn.accept(true)
        canAdd.accept(true)
//        canEdit.accept(true)
        
//        let testRows: [ModelTableViewCell] = [
//            ModelTableViewCell(checkbox: .hiden, title: "title one", showArrow: true),
//            ModelTableViewCell(checkbox: .empty, title: "title two", percent: 20, showArrow: true),
//            ModelTableViewCell(checkbox: .checked, title: "title three", showArrow: true),
//            ModelTableViewCell(checkbox: .hiden, title: "title four", showArrow: true)
//        ]
//        rows.accept(testRows)
    }
    
    override func reloadTableData (){
        let realm = try! Realm()
        modules = Array(realm.objects(ModelModule.self))
        
        let modulesRows = modules.map{
            ModelTableViewCell(checkbox: .hiden, title: $0.name, showArrow: true)
        }
        rows.accept(modulesRows)
    }
    
    fileprivate func bind() {
        _ = addBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.settingsCoordinator?.addModule()
        }).disposed(by: disposeBag)
    }
}
