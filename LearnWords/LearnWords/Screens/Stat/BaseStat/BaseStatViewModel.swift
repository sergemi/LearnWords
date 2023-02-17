//
//  BaseStatViewModel.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

import Foundation

import RxSwift
import RxCocoa

class BaseStatViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    weak var statCoordinator: StatCoordinatorProtocl? = nil
    
    init() {
    }
}
