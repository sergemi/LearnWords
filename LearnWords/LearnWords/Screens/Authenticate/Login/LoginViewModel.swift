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
    
    init() {
        bind()
    }
    
    fileprivate func bind() {
        
    }
}
