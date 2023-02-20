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
    
    
    init() {
        
    }
}
