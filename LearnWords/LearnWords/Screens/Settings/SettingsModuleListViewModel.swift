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
        
//        details.accept("SettingsModuleListViewModel details\n test test test\ntest")
        details.accept(nil)
        tableHeader.accept(nil)
        hasActionAllBtn.accept(true)
    }
}
