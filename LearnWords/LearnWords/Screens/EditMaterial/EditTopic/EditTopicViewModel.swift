//
//  EditTopicViewModel.swift
//  LearnWords
//
//  Created by sergemi on 22.02.2023.
//

import Foundation

final class EditTopicViewModel: UniversalTableViewModel {
    var coordinator: EditMaterialCoordinatorProtocol? = nil
    private let dataManager: DataManager!

    private let moduleId: String
    private var topicId: String?
    private var topic: Topic?
    var isNew = true
    var isCanAdd = true
    
    init(dataManager: DataManager, moduleId: String, topicId: String, isNew: Bool = false) {
        self.dataManager = dataManager
        self.moduleId = moduleId
        self.topicId = topicId
        self.isNew = isNew
        
        super.init()
        
        UpdateButtonsVisibility()
        
        deleteLineAlertTitle = "Settings.AddTopic.DeleteTableLine.Title".localized()
        deleteLineAlertMessage = "Settings.AddTopic.DeleteTableLine.Message".localized()
        
        namePlaceholder.accept("Settings.AddTopic.name placeholder".localized())
        detailsPlaceholder.accept("Settings.AddTopic.details placeholder".localized())
        tableHeader.accept("Settings.AddTopic.tableHeader".localized())
        
        canEdit.accept(true)
        canSelect.accept(true)
        canDeleteRows.accept(true)
        
        bind()
    }
    
    convenience init(dataManager: DataManager, moduleId: String) {
        let newTopic = Topic(name: "",
                             details: "",
                             words: [],
                             exercises: [])
        
        self.init(dataManager: dataManager,
                  moduleId: moduleId,
                  topicId: newTopic.id,
                  isNew: true
                  )
        topic = newTopic
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
            
            self.topic?.name = self.name.value ?? ""
            self.topic?.details = self.details.value ?? ""
            
            if self.topic == nil {
                return
            }
            
            Task { [weak self] in
                guard let self = self else {
                    return
                }
                do {
                    if self.isNew { // todo: try remove !
                        try await self.dataManager.addTopic(self.topic!, moduleId: self.moduleId)
                        self.isNew = false
                        DispatchQueue.main.async {
                            self.UpdateButtonsVisibility()
                            self.haveRightBarBtn.accept(self.isAddBtnEnabled())
                        }
                    } 
                    else {
                        try await self.dataManager.updateTopic(self.topic!, moduleId: self.moduleId)
                        self.isNew = false
                        DispatchQueue.main.async {
                            self.UpdateButtonsVisibility()
                            self.haveRightBarBtn.accept(self.isAddBtnEnabled())
                        }
                    }
                }
                catch {
                    if let error = error as? LocalizedError {
                        print(error.localizedDescription)
                    } else {
                        print("An unexpected error occurred: \(error)")
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        _ = addBtnObserver.bind(onNext: { [weak self] _ in
            guard let topic = self?.topic else {
                return
            }
            self?.coordinator?.addWord(topicId: topic.id)
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
            return topic?.name != newName || topic?.details != newDetails
        }
    }
    
    override func reloadData(){
        log.method()
        if isNew {
            return
        }
        guard let topicId = topicId else {
            return
        }
        
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.topic = try await dataManager.topic(id: topicId)
                guard let topic = self.topic else {
                    return
                }
                
                let wordRows = topic.words.map{
                    ModelTableViewCell(checkbox: .empty,
                                       title: "\($0.word.target) - \($0.word.translate)",
                                       showArrow: true)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.name.accept(topic.name)
                    self?.details.accept(topic.details)
                    self?.rows.accept(wordRows)
                }
            }
            catch {
                if let error = error as? LocalizedError {
                    print(error.localizedDescription)
                } else {
                    print("An unexpected error occurred: \(error)")
                }
            }
        }
    }
    
    override func selectRow(index: Int) {
        guard let topic = topic else {
            return
        }
        let word = topic.words[index]
        self.coordinator?.editWord(topicId: topic.id, learnedWord: word)
    }
    
    override func deleteRow(index: Int) {
        guard let topic = topic else {
            return
        }
        let word = topic.words[index]
        
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                try await self.dataManager.deleteWord(word, topicId: topic.id)
                self.reloadData() // todo: add update only table
            }
            catch {
                if let error = error as? LocalizedError {
                    print(error.localizedDescription)
                } else {
                    print("An unexpected error occurred: \(error)")
                }
            }
        }
    }
}
