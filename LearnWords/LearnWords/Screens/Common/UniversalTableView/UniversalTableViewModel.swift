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
    
    let title = BehaviorRelay<String?>(value: "")
    let name = BehaviorRelay<String?>(value: "")
    let namePlaceholder = BehaviorRelay<String?>(value: "")
    let details = BehaviorRelay<String?>(value: "")
    let detailsPlaceholder = BehaviorRelay<String?>(value: "")
    let tableHeader = BehaviorRelay<String?>(value: "")
    let rightBarBtnCaption = BehaviorRelay<String?>(value: "Add")
    
    let rows = BehaviorRelay<[ModelTableViewCell]>(value: [])
    
    let haveRightBarBtn = BehaviorRelay<Bool>(value: false)
    let canDelete = BehaviorRelay<Bool>(value: false)
    let canEdit = BehaviorRelay<Bool>(value: false)
    let canSelect = BehaviorRelay<Bool>(value: false)
    let canMultiSelect = BehaviorRelay<Bool>(value: false)
    let hasActionAllBtn = BehaviorRelay<Bool>(value: false)
    
    let addBtnObserver = PublishSubject<Void>()
    
    // delete table line
    var deleteLineAlertTitle = "DeleteTableLine.Title".localized()
    var deleteLineAlertMessage = "DeleteTableLine.Message".localized()
    var deleteLineAlertYesTitle = "Yes".localized()
    var deleteLineAlertNoTitle = "No".localized()
    
    func reloadTableData () {
        log.method()
    }
    
    func selectRow(index: Int) {
        log.method()
    }
    
    func deleteRow(index: Int) {
        log.method()
    }
}
