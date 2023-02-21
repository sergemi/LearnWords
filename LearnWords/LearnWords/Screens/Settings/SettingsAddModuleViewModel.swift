//
//  SettingsAddModule.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation

class SettingsAddModuleViewModel: UniversalTableViewModel {
    var settingsCoordinator: SettingsCoordinatorProtocol? = nil
    
    override init() {
        log.method()
        super.init()
        bind()
        
        name.accept("Settings.AddModule.name".localized())
        namePlaceholder.accept("Settings.AddModule.name placeholder".localized())
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
            print("++++++")
        }).disposed(by: disposeBag)
    }
}
