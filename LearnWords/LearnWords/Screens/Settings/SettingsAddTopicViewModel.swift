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

    var module: ModelModule
    var topic: ModelTopic
    var isNew = true
    var isCanAdd = true
    
    var words: [ModelLearnedWord] = []
    
    init(module: ModelModule, topic: ModelTopic, isNew: Bool = false) {
        self.module = module
        self.topic = topic
        self.isNew = isNew
        
        super.init()
        
        UpdateButtonsVisibility()
        
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
    
    func UpdateButtonsVisibility() {
        if isNew {
            title.accept("Settings.AddTopic.Title".localized())
            rightBarBtnCaption.accept("Settings.AddTopic.saveModuleBtn".localized())
            canAdd.accept(false)
        }
        else {
            title.accept("Settings.EditTopic.Title".localized())
            rightBarBtnCaption.accept("Settings.EditTopic.saveModuleBtn".localized())
            canAdd.accept(isCanAdd)
        }
    }
    
    convenience init(module: ModelModule) {
        self.init(module: module, topic: ModelTopic(), isNew: true)
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
                    self.module.topics.append(self.topic)
                }
                self.isNew = false
                self.UpdateButtonsVisibility()
                self.haveRightBarBtn.accept(self.isAddBtnEnabled())
            }
        }).disposed(by: disposeBag)
        
        _ = addBtnObserver.bind(onNext: { [weak self] _ in
            guard let topic = self?.topic else {
                return
            }
            self?.settingsCoordinator?.newWord(topic: topic)
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
    
    override func reloadTableData(){
        let realm = try! Realm()
        words = Array(topic.words)
        
        let wordRows = words.map{
            ModelTableViewCell(checkbox: .empty, title: $0.word?.target ?? "", showArrow: true)
        }
        rows.accept(wordRows)
    }
    
    override func selectRow(index: Int) {
        let word = words[index]
        self.settingsCoordinator?.editWord(topic: topic, learnedWord: word)
    }
}
