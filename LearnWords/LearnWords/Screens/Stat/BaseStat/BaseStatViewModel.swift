//
//  BaseStatViewModel.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

import Foundation

import RxSwift
import RxCocoa

final class BaseStatViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    weak var coordinator: StatCoordinatorProtocol? = nil
    
    init(coordinator: StatCoordinatorProtocol) {
        self.coordinator = coordinator
    }
}
