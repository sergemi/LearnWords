//
//  MainTabBarViewModel.swift
//  LearnWord
//
//  Created by sergemi on 11.02.2021.
//

import Foundation
import RxSwift
import RxCocoa

class MainTabBarViewModel: BaseViewModel {
    enum tabType: Int {
        case learn
        case addWord
        case stat
        case settings
    }
    
    let tabs: [MainTabBarViewModel.tabType] = [
        .learn,
        .addWord,
        .stat,
        .settings
    ]
    
    func getTitle(_ type: tabType) -> String {
        switch type {
        case .learn:
            return "Tabbar.Learn".localized()
            
        case .addWord:
            return "Tabbar.AddWord".localized()
            
        case .stat:
            return "Tabbar.Stat".localized()
            
        case .settings:
            return "Tabbar.Settings".localized()
        }
    }
    
    func getIconName(_ type: tabType) -> String {
        switch type {
        case .learn:
            return "tabbar_dashboard"
            
        case .addWord:
            return "tabbar_disinfect"
            
        case .stat:
            return "tabbar_locations"
            
        case .settings:
            return "tabbar_sync"
        }
    }
    
    func getCoordinator(_ type: tabType) -> CoordinatorProtocol {
        switch type {
        case .learn:
            return LearnCoordinator()

        case .addWord:
            return LearnCoordinator()

        case .stat:
//            return StatCoordinator()
            return EditMaterialCoordinator()

        case .settings:
            return SettingsCoordinator()
        }
    }

}
