//
//  SettingsAddModule.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation

final class EditModuleViewModel: UniversalTableViewModel {
    private weak var coordinator: EditMaterialCoordinatorProtocol? = nil
    private let dataManager: DataManager!
    
    private var moduleId: String?
    private var module: Module?
    private var isNew = true
    private var isCanAdd = true
    
    init(dataManager: DataManager, coordinator: EditMaterialCoordinatorProtocol?, moduleId: String, isNew: Bool = false) {
        self.dataManager = dataManager
        self.coordinator = coordinator
        self.moduleId = moduleId
        self.isNew = isNew
        
        super.init()
        
        deleteLineAlertTitle = "Settings.AddModule.DeleteTableLine.Title".localized()
        deleteLineAlertMessage = "Settings.AddModule.DeleteTableLine.Message".localized()
        
        UpdateButtonsVisibility()
        
        namePlaceholder.accept("Settings.AddModule.name placeholder".localized())
        detailsPlaceholder.accept("Settings.AddModule.details placeholder".localized())
        tableHeader.accept("Settings.AddModule.tableHeader".localized())
                
        canEdit.accept(true)
        canSelect.accept(true)
        canDeleteRows.accept(true)
        
        bind()
    }
    
    convenience init(dataManager: DataManager, coordinator: EditMaterialCoordinatorProtocol?) {
        let newModule = Module(name: "",
                               details: "",
                               topics: [],
                               author: AuthManager.userId ?? "guest",
                               isPublic: false)
        
        self.init(dataManager: dataManager,
                  coordinator: coordinator,
                  moduleId: newModule.id,
                  isNew: true)
        
        module = newModule
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
        
    fileprivate func bind() {
        _ = rightBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            print("++ Saving Module ++")
            print("name: \(String(describing: (self.name.value) ?? ""))")
            print("details: \(String(describing: (self.details.value) ?? ""))")
            
            self.module?.name = self.name.value ?? ""
            self.module?.details = self.details.value ?? ""
            
            if self.module == nil {
                return
            }
            
            Task { [weak self] in
                guard let self = self else {
                    return
                }
                do {
                    if self.isNew {
                        try await self.dataManager.addModule(self.module!)
                        
                        self.isNew = false
                        DispatchQueue.main.async {
                            self.UpdateButtonsVisibility()
                            self.haveRightBarBtn.accept(self.isAddBtnEnabled())
                        }
                    }
                    else {
                        try await self.dataManager.updateModule(self.module!)
                        
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
            guard let module = self?.module else {
                return
            }
            self?.coordinator?.addTopic(moduleId: module.id)
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
            return module?.name != newName || module?.details != newDetails
        }
    }
    
    override func reloadData(){
        log.method()
        if isNew {
            return
        }
        guard let moduleId = moduleId else {
            return
        }
        
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.module = try await dataManager.module(id: moduleId) // todo: is it still need?
                guard let module = self.module else {
                    return
                }
                
                let topicsRows = module.topics.map{
                    ModelTableViewCell(checkbox: .empty, title: $0.name, showArrow: true)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.name.accept(module.name)
                    self?.details.accept(module.details)
                    self?.rows.accept(topicsRows)
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
        guard let moduleId = moduleId, let topicId = module?.topics[index].id else {
            return
        }
        self.coordinator?.editTopic(moduleId: moduleId, topicId: topicId)
    }
    
    override func deleteRow(index: Int) {
        guard let topicId = module?.topics[index].id, let moduleId = module?.id else {
            return
        }
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                try await self.dataManager.deleteTopic(id: topicId, moduleId: moduleId)
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
