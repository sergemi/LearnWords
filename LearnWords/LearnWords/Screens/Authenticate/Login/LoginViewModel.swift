//
//  LoginViewModel.swift
//  LearnWords
//
//  Created by sergemi on 05.04.2024.
//

import Foundation

import RxSwift
import RxCocoa

class LoginViewModel : BaseViewModel {
    let disposeBag = DisposeBag()
    weak var authenticateCoordinator: AuthenticateProtocol?
    weak var showErrorDelegate: ShowErrorProtocol? = nil
    
    let title = BehaviorRelay<String?>(value: "Login".localized())
    
    let loginPlaceholder = BehaviorRelay<String?>(value: "E-mail".localized())
    let passwordPlaceholder = BehaviorRelay<String?>(value: "Password".localized())
    let loginBtnCaption = BehaviorRelay<String?>(value: "Login".localized())
    let signUpBtnCaption = BehaviorRelay<String?>(value: "Sign Up".localized())
    
    
    let loginBtnObserver = PublishSubject<Void>()
    let signUpBtnObserver = PublishSubject<Void>()
    
    let email = BehaviorRelay<String?>(value: "")
    let password = BehaviorRelay<String?>(value: "")
    
    init() {
        bind()
    }
    
    fileprivate func bind() {
        _ = loginBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self,
                  let email = self.email.value,
                  let password = self.password.value
            else {
                return
            }
            
            AuthManager.login(email: email, password: password) { [weak self] result, error in
                if let error = error {
                    self?.showErrorDelegate?.errorAlert(error)
                } else if result != nil{
                    if let baseCoordinator = self?.authenticateCoordinator as? CoordinatorProtocol {
                        baseCoordinator.returnToParrent()
                    }
                } else {
                    self?.showErrorDelegate?.errorAllert("Unknown login error")
                }
            }
        }).disposed(by: disposeBag)
        
        _ = signUpBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.authenticateCoordinator?.signUp()
        }).disposed(by: disposeBag)
    }
}
