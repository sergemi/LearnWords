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
    weak var settingsCoordinator: SettingsCoordinatorProtocol? = nil
    
    let localBaseBtnObserver = PublishSubject<Void>()
    let editWordsBtnObserver = PublishSubject<Void>()
    
    
    init() {
        _ = localBaseBtnObserver.bind(onNext: { [weak self] _ in
//            print("!localBaseBtnObserver!")
            let settingsURL = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }).disposed(by: disposeBag)
        
        _ = editWordsBtnObserver.bind(onNext: { [weak self] _ in
            print("!editWordsBtnObserver!")
            self?.settingsCoordinator?.selectModule()
        }).disposed(by: disposeBag)
    }
}
