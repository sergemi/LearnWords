//
//  BaseLearnViewModel.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

import Foundation

import RxSwift
import RxCocoa

class BaseLearnViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    weak var learnCoordinator: LearnCoordinatorProtocol? = nil
    
    let newBtnObserver = PublishSubject<Void>()
    let continueBtnObserver = PublishSubject<Void>()
    
    init() {
        bind()
    }
    
    fileprivate func bind() {
        _ = newBtnObserver.bind(onNext: { [weak self] _ in
            self?.learnCoordinator?.selectModule() //todo: return back
        }).disposed(by: disposeBag)
        
        _ = continueBtnObserver.bind(onNext: { [ weak self] _ in
            self?.learnCoordinator?.test()
        }).disposed(by: disposeBag)
    }
}
