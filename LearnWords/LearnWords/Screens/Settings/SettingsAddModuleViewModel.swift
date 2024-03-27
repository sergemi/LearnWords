//
//  SettingsAddModule.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class SettingsAddModuleViewModel: UniversalTableViewModel {
    var settingsCoordinator: SettingsCoordinatorProtocol? = nil
    
    var module: ModelModule
    var isNew = true
    var isCanAdd = true
    
    var topics: [ModelTopic] = []
    
    init(module: ModelModule, isNew: Bool = false) {
        self.module = module
        self.isNew = isNew
        
        super.init()
        
        deleteLineAlertTitle = "Settings.AddModule.DeleteTableLine.Title".localized()
        deleteLineAlertMessage = "Settings.AddModule.DeleteTableLine.Message".localized()
        
        UpdateButtonsVisibility()
        
        namePlaceholder.accept("Settings.AddModule.name placeholder".localized())
        detailsPlaceholder.accept("Settings.AddModule.details placeholder".localized())
        tableHeader.accept("Settings.AddModule.tableHeader".localized())
        name.accept(module.name)
        details.accept(module.details)
        
        canEdit.accept(true)
//        canAdd.accept(true)
        canSelect.accept(true)
        canDeleteRows.accept(true)
//        haveRightBarBtn.accept(true)
        
        bind()
    }
    
    func UpdateButtonsVisibility() {
        if isNew {
            title.accept("Settings.AddModule.Title".localized())
            rightBarBtnCaption.accept("Settings.AddModule.saveModuleBtn".localized())
            canAdd.accept(false)
        }
        else {
            title.accept("Settings.EditModule.Title".localized())
            rightBarBtnCaption.accept("Settings.EditModule.saveModuleBtn".localized())
            canAdd.accept(isCanAdd)
        }
    }
    
    convenience override init() {
        self.init(module: ModelModule(), isNew: true)
    }
        
    fileprivate func bind() {
        _ = rightBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            print("++ Save Module ++")
            print("name: \(String(describing: (self.name.value) ?? ""))")
            print("details: \(String(describing: (self.details.value) ?? ""))")
            
            let realm = try! Realm()
            try! realm.write {
                self.module.name = self.name.value ?? ""
                self.module.details = self.details.value ?? ""
                if self.isNew {
                    realm.add(self.module)
                }
                self.isNew = false
                self.UpdateButtonsVisibility()
                self.haveRightBarBtn.accept(self.isAddBtnEnabled())
            }
        }).disposed(by: disposeBag)
        
        _ = addBtnObserver.bind(onNext: { [weak self] _ in
            guard let module = self?.module else {
                return
            }
            self?.settingsCoordinator?.addTopic(module: module)
        }).disposed(by: disposeBag)
        
        _ = details.subscribe(onNext: { [weak self] value in
            guard let self = self else {
                return
            }
            self.haveRightBarBtn.accept(self.isAddBtnEnabled())
        }).disposed(by: disposeBag)

        _ = name.subscribe(onNext: { [weak self] value in
            guard let self = self else {
                return
            }
            self.haveRightBarBtn.accept(self.isAddBtnEnabled())
        }).disposed(by: disposeBag)
    }
    
    func isAddBtnEnabled() -> Bool {
        guard let newName = name.value, let newDetails = details.value else {
            return false
        }
        if newName.isEmpty {
            return false
        }
            
        if isNew {
            return true
        }
        else {
            return module.name != newName || module.details != newDetails
        }
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
        self.settingsCoordinator?.editTopic(module: module, topic: topic)
    }
    
    override func deleteRow(index: Int) {
        log.method()
    
        let realm = try! Realm()
        try! realm.write {
            module.topics.remove(at: index)
        }
        reloadTableData()
    }
}
