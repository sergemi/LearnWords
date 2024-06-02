//
//  SettingsMainMenuViewModel.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

import Foundation

import RxSwift
import RxCocoa

final class SettingsMainMenuViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    private weak var coordinator: SettingsCoordinatorProtocol?
    
    let localBaseBtnObserver = PublishSubject<Void>()
    let editWordsBtnObserver = PublishSubject<Void>()
    let logoutBtnObserver = PublishSubject<Void>()
    
    
    init(coordinator: SettingsCoordinatorProtocol) {
        self.coordinator = coordinator
        
        _ = localBaseBtnObserver.bind(onNext: {_ in
            let settingsURL = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }).disposed(by: disposeBag)
        
        _ = editWordsBtnObserver.bind(onNext: { [weak self] _ in
            print("!editWordsBtnObserver!")
            self?.coordinator?.editMaterial()
        }).disposed(by: disposeBag)
        
        _ = logoutBtnObserver.bind(onNext: { _ in
            print("!logoutBtnObserver!")
            
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(5)) {                     AuthManager.logOut()
            }
            
            
        }).disposed(by: disposeBag)
    }
}
