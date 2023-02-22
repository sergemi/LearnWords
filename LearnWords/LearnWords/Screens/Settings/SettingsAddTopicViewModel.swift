//
//  SettingsAddTopicViewModel.swift
//  LearnWords
//
//  Created by sergemi on 22.02.2023.
//

import Foundation
import RealmSwift

class SettingsAddTopicViewModel: UniversalTableViewModel {
    var settingsCoordinator: SettingsCoordinatorProtocol? = nil
    
    var topic: ModelTopic
    var isNew = true
    
    init(topic: ModelTopic, isNew: Bool = false) {
        self.topic = topic
        self.isNew = isNew
        
        super.init()
        
        if isNew {
            title.accept("Settings.AddTopic.Title".localized())
            rightBarBtnCaption.accept("Settings.AddTopic.saveModuleBtn".localized())
        }
        else {
            title.accept("Settings.EditTopic.Title".localized())
            rightBarBtnCaption.accept("Settings.EditTopic.saveModuleBtn".localized())
        }
        
        namePlaceholder.accept("Settings.AddTopic.name placeholder".localized())
        tableHeader.accept("Settings.AddTopic.tableHeader".localized())
        name.accept(topic.name)
        details.accept(topic.details)
        
        canEdit.accept(true)
        canAdd.accept(true)
        canSelect.accept(true)
//        haveRightBarBtn.accept(true)
        
        bind()
    }
    
    convenience override init() {
        self.init(topic: ModelTopic(), isNew: true)
    }
    
    fileprivate func bind() {
        _ = rightBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            print("++ Save topic ++")
            print("name: \(String(describing: (self.name.value) ?? ""))")
            print("details: \(String(describing: (self.details.value) ?? ""))")
            
            let realm = try! Realm()
            try! realm.write {
                self.topic.name = self.name.value ?? ""
                self.topic.details = self.details.value ?? ""
                if self.isNew {
                    realm.add(self.topic)
                }
            }
        }).disposed(by: disposeBag)
        
        _ = details.subscribe(onNext: { [weak self] value in
            guard let self = self, let value = value else {
                return
            }
            self.haveRightBarBtn.accept(self.isAddBtnEnabled())
        }).disposed(by: disposeBag)

        _ = name.subscribe(onNext: { [weak self] value in
            guard let self = self, let value = value else {
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
            return topic.name != newName || topic.details != newDetails
        }
    }
}
