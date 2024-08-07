//
//  LoginViewModel.swift
//  LearnWords
//
//  Created by sergemi on 05.04.2024.
//

import Foundation

import RxSwift
import RxCocoa

import FirebaseCore // ?
import FirebaseAuth
import GoogleSignIn // ?

final class LoginViewModel : BaseViewModel {
    let disposeBag = DisposeBag()
    private weak var coordinator: AuthenticateProtocol?
    weak var showErrorDelegate: ShowErrorProtocol? = nil
    
    let title = BehaviorRelay<String?>(value: "Login".localized())
    
    let loginPlaceholder = BehaviorRelay<String?>(value: "E-mail".localized())
    let passwordPlaceholder = BehaviorRelay<String?>(value: "Password".localized())
    let loginBtnCaption = BehaviorRelay<String?>(value: "Login".localized())
    let signUpBtnCaption = BehaviorRelay<String?>(value: "Sign Up".localized())
    
    let googleBtnObserver = PublishSubject<Void>()
    let loginBtnObserver = PublishSubject<Void>()
    let signUpBtnObserver = PublishSubject<Void>()
    
    let email = BehaviorRelay<String?>(value: "")
    let password = BehaviorRelay<String?>(value: "")
    
    init(coordinator: AuthenticateProtocol?) {
        self.coordinator = coordinator
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
            
            Task {
                do {
                    _ = try await AuthManager.login(email: email, password: password)
                    self.returnToParrentCoordinator()
                }
                catch {
                    DispatchQueue.main.async {
                        self.showErrorDelegate?.errorAlert(error)
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        _ = signUpBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.coordinator?.signUp()
        }).disposed(by: disposeBag)
    }
    
    fileprivate func returnToParrentCoordinator() {
        if let baseCoordinator = self.coordinator as? CoordinatorProtocol {
            DispatchQueue.main.async {
                baseCoordinator.returnToParrent()
            }
        }
    }
    
    func onGoogleLogin(credential: AuthCredential) {
        log.method()
        
        Task {
            do {
                _ = try await AuthManager.loginGoogle(credential: credential)
                
                returnToParrentCoordinator()
            }
            catch {
                DispatchQueue.main.async {
                    self.showErrorDelegate?.errorAlert(error)
                }
            }
        }
    }
}
