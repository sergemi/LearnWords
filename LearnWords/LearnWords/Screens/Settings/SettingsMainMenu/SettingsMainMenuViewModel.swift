//
//  SettingsMainMenuViewModel.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

import Foundation

import RxSwift
import RxCocoa

class SettingsMainMenuViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    weak var settingsCoordinator: SettingsCoordinatorProtocl? = nil
}
