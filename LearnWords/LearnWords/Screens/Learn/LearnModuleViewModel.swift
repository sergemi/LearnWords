//
//  LearnModuleViewModel.swift
//  LearnWords
//
//  Created by sergemi on 22.02.2023.
//

import Foundation
import RealmSwift

class LearnModuleViewModel: UniversalTableViewModel {
    var learnCoordinator: LearnCoordinatorProtocol? = nil
    
    var module: ModelModule
    
    init(module: ModelModule) {
        self.module = module
        super.init()
        
        title.accept("Learn.Module.Title".localized())
        tableHeader.accept("Learn.Module.tableHeader".localized())
        
        name.accept(module.name)
        details.accept(module.details)
    }
}
