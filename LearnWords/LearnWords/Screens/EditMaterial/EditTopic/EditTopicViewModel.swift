//
//  EditTopicViewModel.swift
//  LearnWords
//
//  Created by sergemi on 22.02.2023.
//

import Foundation
import RealmSwift

class EditTopicViewModel: UniversalTableViewModel {
    var coordinator: EditMaterialCoordinatorProtocol? = nil
    let dataManager: DataManager!

    var module: Module
    var topic: Topic
    var isNew = true
    var isCanAdd = true
    
    var words: [LearnedWord] = []
    
    init(dataManager: DataManager, module: Module, topic: Topic, isNew: Bool = false) {
        self.dataManager = dataManager
        self.module = module
        self.topic = topic
        self.isNew = isNew
        
        super.init()
        
        UpdateButtonsVisibility()
        
        deleteLineAlertTitle = "Settings.AddTopic.DeleteTableLine.Title".localized()
        deleteLineAlertMessage = "Settings.AddTopic.DeleteTableLine.Message".localized()
        
        namePlaceholder.accept("Settings.AddTopic.name placeholder".localized())
        detailsPlaceholder.accept("Settings.AddTopic.details placeholder".localized())
        tableHeader.accept("Settings.AddTopic.tableHeader".localized())
        name.accept(topic.name)
        details.accept(topic.details)
        
        canEdit.accept(true)
//        canAdd.accept(true)
        canSelect.accept(true)
        canDeleteRows.accept(true)
        
        bind()
    }
    
    convenience init(dataManager: DataManager, module: Module) {
        self.init(dataManager: dataManager,
                  module: module,
                  topic: Topic(),
                  isNew: true
                  )
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
    
    fileprivate func bind() {
        _ = rightBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            print("++ Save topic ++")
            print("name: \(String(describing: (self.name.value) ?? ""))")
            print("details: \(String(describing: (self.details.value) ?? ""))")
            
            self.topic.name = self.name.value ?? ""
            self.topic.details = self.details.value ?? ""
            if isNew {
                let res = self.dataManager.addTopic(moduleId: self.module.id, topic: self.topic)
                // TODO: show error
                print(res)
            } else {
                let res = self.dataManager.updateTopic(moduleId: self.module.id, topic: self.topic)
                // TODO: show error
                print(res)
            }
            self.isNew = false
            self.UpdateButtonsVisibility()
            self.haveRightBarBtn.accept(self.isAddBtnEnabled())
            
//            let realm = try! Realm()
//            try! realm.write {
//                self.topic.name = self.name.value ?? ""
//                self.topic.details = self.details.value ?? ""
//                if self.isNew {
//                    self.module.topics.append(self.topic)
//                }
//                self.isNew = false
//                self.UpdateButtonsVisibility()
//                self.haveRightBarBtn.accept(self.isAddBtnEnabled())
//            }
        }).disposed(by: disposeBag)
        
        _ = addBtnObserver.bind(onNext: { [weak self] _ in
            guard let topic = self?.topic else {
                return
            }
            self?.coordinator?.editWord(topic: topic)
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
            return topic.name != newName || topic.details != newDetails
        }
    }
    
    override func reloadTableData(){
//        let realm = try! Realm()
        
        guard let updatedTopic = dataManager.topic(id: topic.id) else {
            return
        }
        topic = updatedTopic
        words = Array(topic.words)
        
        let wordRows = words.map{
//            ModelTableViewCell(checkbox: .empty, title: $0.word?.target ?? "", showArrow: true)
            ModelTableViewCell(checkbox: .empty,
                               title: "\($0.word.target) - \($0.word.translate)",
                               showArrow: true)
        }
        rows.accept(wordRows)
    }
    
    override func selectRow(index: Int) {
        let word = words[index]
        self.coordinator?.editWord(topic: topic, learnedWord: word)
    }
    
    override func deleteRow(index: Int) {
        let word = words[index]
        _ = dataManager.deleteWord(topicId: topic.id, word: word)
        //TODO: show error
//        let realm = try! Realm()
//        try! realm.write {
//            topic.words.remove(at: index)
//        }
        reloadTableData()
    }
}
