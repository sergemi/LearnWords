//
//  BaseLearnViewModel.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

import Foundation

import RxSwift
import RxCocoa

final class BaseLearnViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    private weak var coordinator: LearnCoordinatorProtocol? = nil
    
    let newBtnObserver = PublishSubject<Void>()
    let continueBtnObserver = PublishSubject<Void>()
    
    init(coordinator: LearnCoordinatorProtocol) {
        self.coordinator = coordinator
        bind()
    }
    
    fileprivate func bind() {
        _ = newBtnObserver.bind(onNext: { [weak self] _ in
            self?.coordinator?.selectModule() //todo: return back
        }).disposed(by: disposeBag)
        
        _ = continueBtnObserver.bind(onNext: { [ weak self] _ in
            self?.coordinator?.test()
        }).disposed(by: disposeBag)
    }
}
