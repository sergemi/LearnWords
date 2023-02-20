//
//  UniversalTableViewModel.swift
//  LearnWords
//
//  Created by sergemi on 19.02.2023.
//

import Foundation

import RxSwift
import RxCocoa

//protocol UniversalTableViewModel: BaseViewModel {
class UniversalTableViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    let name = BehaviorRelay<String?>(value: "")
    let details = BehaviorRelay<String?>(value: "")
    let tableHeader = BehaviorRelay<String?>(value: "")
    
    let rows = BehaviorRelay<[ModelTableViewCell]>(value: [])
    
    let canAdd = BehaviorRelay<Bool>(value: false)
    let canDelete = BehaviorRelay<Bool>(value: false)
    let canEdit = BehaviorRelay<Bool>(value: false)
    let canSelect = BehaviorRelay<Bool>(value: false)
    let canMultiSelect = BehaviorRelay<Bool>(value: false)
    let hasActionAllBtn = BehaviorRelay<Bool>(value: false)
    
    let addBtnObserver = PublishSubject<Void>()
}
