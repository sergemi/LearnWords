//
//  SignUpViewModel.swift
//  LearnWords
//
//  Created by sergemi on 07.04.2024.
//

import Foundation

import RxSwift
import RxCocoa

class SignUpViewModel : BaseViewModel {
    let disposeBag = DisposeBag()
    weak var authenticateCoordinator: AuthenticateProtocol?
    
    let title = BehaviorRelay<String?>(value: "Sign up".localized())
    
    let loginPlaceholder = BehaviorRelay<String?>(value: "E-mail".localized())
    let password1Placeholder = BehaviorRelay<String?>(value: "Password".localized())
    let password2Placeholder = BehaviorRelay<String?>(value: "Re enter Password".localized())
    let signUpBtnCaption = BehaviorRelay<String?>(value: "Sign Up".localized())
    
    let signUpBtnObserver = PublishSubject<Void>()
    let email = BehaviorRelay<String?>(value: "")
    let password1 = BehaviorRelay<String?>(value: "")
    let password2 = BehaviorRelay<String?>(value: "")
    
    init() {
        bind()
    }
    
    fileprivate func bind() {
        _ = signUpBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            print("Sign up!!!")
        }).disposed(by: disposeBag)
    }
}
