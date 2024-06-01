//
//  SignUpViewModel.swift
//  LearnWords
//
//  Created by sergemi on 07.04.2024.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

final class SignUpViewModel : BaseViewModel {
    let disposeBag = DisposeBag()
    private weak var authenticateCoordinator: AuthenticateProtocol?
    weak var showErrorDelegate: ShowErrorProtocol? = nil
    
    let title = BehaviorRelay<String?>(value: "Sign up".localized())
    
    let loginPlaceholder = BehaviorRelay<String?>(value: "E-mail".localized())
    let password1Placeholder = BehaviorRelay<String?>(value: "Password".localized())
    let password2Placeholder = BehaviorRelay<String?>(value: "Confirm Password".localized())
    let signUpBtnCaption = BehaviorRelay<String?>(value: "Sign Up".localized())
    
    let signUpBtnObserver = PublishSubject<Void>()
    let email = BehaviorRelay<String?>(value: "")
    let password1 = BehaviorRelay<String?>(value: "")
    let password2 = BehaviorRelay<String?>(value: "")
    
    init(coordinator: AuthenticateProtocol?) {
        authenticateCoordinator = coordinator
        bind()
    }
    
    fileprivate func bind() {
        _ = signUpBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self,
                  let email = self.email.value,
                  let password1 = self.password1.value,
                  let password2 = self.password2.value
            else {
                self?.showErrorDelegate?.errorAllert("Some field is empty")
                return
            }
            if password1 != password2 {
                self.showErrorDelegate?.errorAllert("Passwords mismatch")
                return
            }
            else if (password1.count < 6 || password2.count < 6) {
                self.showErrorDelegate?.errorAllert("Password must be at last 6 symbols")
                return
            }
            else {
                AuthManager.createUserAndLogin(email: email, password: password1) {[weak self] result, error in
                    if let error = error {
                        self?.showErrorDelegate?.errorAlert(error)
                        return
                    }
                    if result != nil {
                        if let baseCoordinator = self?.authenticateCoordinator as? CoordinatorProtocol {
                            baseCoordinator.returnToParrent()
                        }
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
}
