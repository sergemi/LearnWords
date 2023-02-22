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
    
    var module: ModelModule// = ModelModule()
    var isNew = true
    
    init(module: ModelModule, isNew: Bool = false) {
        self.module = module
        self.isNew = isNew
        
        super.init()
        
        if isNew {
            title.accept("Settings.AddModule.Title".localized())
            addBtnCaption.accept("Settings.AddModule.saveModuleBtn".localized())
        }
        else {
            title.accept("Settings.EditModule.Title".localized())
            addBtnCaption.accept("Settings.EditModule.saveModuleBtn".localized())
        }
        
        namePlaceholder.accept("Settings.AddModule.name placeholder".localized())
        tableHeader.accept("Settings.AddModule.tableHeader".localized())
        name.accept(module.name)
        details.accept(module.details)
        
        canEdit.accept(true)
//        canAdd.accept(true)
        
        bind()
    }
    
    convenience override init() {
        self.init(module: ModelModule(), isNew: true)
    }
    
//    override init() {
//        log.method()
//        super.init()
//        bind()
//
//        title.accept("Settings.AddModule.Title".localized())
//        namePlaceholder.accept("Settings.AddModule.title placeholder".localized())
//        tableHeader.accept("Settings.AddModule.tableHeader".localized())
//        addBtnCaption.accept("Settings.AddModule.saveModuleBtn".localized())
//        canEdit.accept(true)
//        canAdd.accept(true)
//    }
    
    fileprivate func bind() {
        _ = addBtnObserver.bind(onNext: { [weak self] _ in
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
            }
        }).disposed(by: disposeBag)
        _ = details.subscribe(onNext: { [weak self] value in
            guard let self = self, let value = value else {
                return
            }
            self.canAdd.accept(self.isAddBtnEnabled())
        }).disposed(by: disposeBag)

        _ = name.subscribe(onNext: { [weak self] value in
            guard let self = self, let value = value else {
                return
            }
            self.canAdd.accept(self.isAddBtnEnabled())
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
}
