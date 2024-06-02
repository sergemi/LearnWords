//
//  LearnModulesListViewModel.swift
//  LearnWords
//
//  Created by sergemi on 22.02.2023.
//

import Foundation

final class LearnModulesListViewModel: UniversalTableViewModel {
    private weak var coordinator: LearnCoordinatorProtocol?
    private let dataManager: DataManager!
    private var modules: [ModulePreload] = []
    
    init(dataManager: DataManager, coordinator: LearnCoordinatorProtocol) {
        log.method()
        self.dataManager = dataManager
        self.coordinator = coordinator
        super.init()
        
        title.accept("Learn.ModulesList.Title".localized())
        
        canSelect.accept(true)
    }
    
    override func reloadData() {
        log.method()
        Task {
            do {
                modules = try await dataManager.modules
                let modulesRows = modules.map{
                    ModelTableViewCell(checkbox: .hiden,
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
        self.coordinator?.module(module.id)
    }
}
