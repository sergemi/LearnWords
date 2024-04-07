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

class SignUpViewModel : BaseViewModel {
    let disposeBag = DisposeBag()
    weak var authenticateCoordinator: AuthenticateProtocol?
    
    let title = BehaviorRelay<String?>(value: "Sign up".localized())
    
    let loginPlaceholder = BehaviorRelay<String?>(value: "E-mail".localized())
    let password1Placeholder = BehaviorRelay<String?>(value: "Password".localized())
    let password2Placeholder = BehaviorRelay<String?>(value: "Confirm Password".localized())
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
            guard let self = self,
                  let email = self.email.value,
                  let password1 = self.password1.value,
                  let password2 = self.password2.value
            else {
                print("Error: some field is empty")
                return
            }
            if password1 != password2 {
                print("Error: Passwords mismatch !")
            }
            Auth.auth().createUser(withEmail: email, password: password1) { _, error in
              // 3
              if error == nil {
                  print("User created sucessfully!")
                Auth.auth().signIn(withEmail: email, password: password1)
              } else {
                print("Error in createUser: \(error?.localizedDescription ?? "")")
              }
            }
            
            
        }).disposed(by: disposeBag)
    }
}
