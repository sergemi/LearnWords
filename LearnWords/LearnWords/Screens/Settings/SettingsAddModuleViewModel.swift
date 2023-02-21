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
    
    var module = ModelModule()
    
    override init() {
        log.method()
        super.init()
        bind()
        
        title.accept("Settings.AddModule.Title".localized())
        namePlaceholder.accept("Settings.AddModule.title placeholder".localized())
//        name.accept("This is the name")
        tableHeader.accept("Settings.AddModule.tableHeader".localized())
        addBtnCaption.accept("Settings.AddModule.saveModuleBtn".localized())
        canEdit.accept(true)
        canAdd.accept(true)
    }
    
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
                realm.add(self.module)
            }
        }).disposed(by: disposeBag)
        
        _ = details.subscribe(onNext: { [weak self] value in
            guard let self = self, let value = value else {
                return
            }
            self.module.details = value
        }).disposed(by: disposeBag)
        
        _ = name.subscribe(onNext: { [weak self] value in
            guard let self = self, let value = value else {
                return
            }
            self.module.name = value
        }).disposed(by: disposeBag)
    }
}
