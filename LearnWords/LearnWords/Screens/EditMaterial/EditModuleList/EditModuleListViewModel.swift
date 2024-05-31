//
//  EditModuleListViewModel.swift
//  LearnWords
//
//  Created by sergemi on 19.02.2023.
//

import Foundation

final class EditModuleListViewModel: UniversalTableViewModel {
    var coordinator: EditMaterialCoordinatorProtocol? = nil
    private let dataManager: DataManager!
    private var modules: [ModulePreload] = []
    
    init(dataManager: DataManager) {
        log.method()
        
        self.dataManager = dataManager
        super.init()
        
        bind()
        
        deleteLineAlertTitle = "Settings.ModulesList.DeleteTableLine.Title".localized()
        deleteLineAlertMessage = "Settings.ModulesList.DeleteTableLine.Message".localized()
        
        title.accept("Settings.ModulesList.Title".localized())
        
        haveRightBarBtn.accept(true)
        canDeleteRows.accept(true)
        canSelect.accept(true)
    }
    
    fileprivate func bind() {
        _ = rightBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.coordinator?.addModule()
        }).disposed(by: disposeBag)
    }
    
    override func reloadData(){
        log.method()
        Task {
            do {
                modules = try await dataManager.modules
                let modulesRows = modules.map{
                    ModelTableViewCell(checkbox: .empty,
                                       title: $0.name,
                                       showArrow: true
                    )
                }
                
                rows.accept(modulesRows)
            } catch {
                if let error = error as? LocalizedError {
                    print(error.localizedDescription)
                } else {
                    print("An unexpected error occurred: \(error)")
                }
                
            }
        }
    }
    
    override func selectRow(index: Int) {
        let module = modules[index]
        self.coordinator?.editModule(module.id)
    }
    
    override func deleteRow(index: Int) {
        Task {
            do {
                let module = modules[index]
                try await dataManager.deleteModule(id: module.id)
                reloadData()
            } catch {
                if let error = error as? LocalizedError {
                    print(error.localizedDescription)
                } else {
                    print("An unexpected error occurred: \(error)")
                }
            }
        }
    }
}
