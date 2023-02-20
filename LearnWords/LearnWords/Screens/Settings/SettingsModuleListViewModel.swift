//
//  SettingsModuleListViewModel.swift
//  LearnWords
//
//  Created by sergemi on 19.02.2023.
//

import Foundation

class SettingsModuleListViewModel: UniversalTableViewModel {
    var settingsCoordinator: SettingsCoordinatorProtocol? = nil
    
    override init() {
        log.method()
        super.init()
        bind()
        
        name.accept("Settings.ModulesList.Name".localized())
        
//        details.accept("SettingsModuleListViewModel details\n test test test\ntest")
//        details.accept(nil)
//        tableHeader.accept(nil)
//        tableHeader.accept("Header")
//        hasActionAllBtn.accept(true)
        canAdd.accept(true)
        
        let testRows: [ModelTableViewCell] = [
            ModelTableViewCell(checkbox: .hiden, title: "title one", showArrow: true),
            ModelTableViewCell(checkbox: .empty, title: "title two", percent: 20, showArrow: true),
            ModelTableViewCell(checkbox: .checked, title: "title three", showArrow: true),
            ModelTableViewCell(checkbox: .hiden, title: "title four", showArrow: true)
        ]
        rows.accept(testRows)
    }
    
    fileprivate func bind() {
        _ = addBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            print("++++++")
        }).disposed(by: disposeBag)
    }
}
