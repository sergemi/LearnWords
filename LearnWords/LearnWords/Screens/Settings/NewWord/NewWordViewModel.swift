//
//  NewWordViewModel.swift
//  LearnWords
//
//  Created by sergemi on 23.02.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class NewWordViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    var settingsCoordinator: SettingsCoordinatorProtocol? = nil
    
    var isNew = true
    var topic: ModelTopic
    var learnedWord: ModelLearnedWord
    
    let title = BehaviorRelay<String?>(value: "")
    let rightBarBtnCaption = BehaviorRelay<String?>(value: "Add")
    let haveRightBarBtn = BehaviorRelay<Bool>(value: true)
    let rightBtnObserver = PublishSubject<Void>()
    
    let target = BehaviorRelay<String?>(value: "")
    let pronounce = BehaviorRelay<String?>(value: "")
    let translate = BehaviorRelay<String?>(value: "")
    let notes = BehaviorRelay<String?>(value: "")
    
    init(topic: ModelTopic, learnedWord: ModelLearnedWord, isNew: Bool = false) {
        self.topic = topic
        self.learnedWord = learnedWord
        self.isNew = isNew
        
        bind()
        UpdateButtonsVisibility()
    }
    
    convenience init(topic: ModelTopic) {
        self.init(topic: topic, learnedWord: ModelLearnedWord(), isNew: true)
    }
    
    fileprivate func bind() {
        _ = target.subscribe(onNext: { [weak self] value in
            guard let self = self else {
                return
            }
            self.haveRightBarBtn.accept(self.isRightBtnEnabled())
        }).disposed(by: disposeBag)
        
        _ = translate.subscribe(onNext: { [weak self] value in
            guard let self = self else {
                return
            }
            self.haveRightBarBtn.accept(self.isRightBtnEnabled())
        }).disposed(by: disposeBag)
    }
    
    func UpdateButtonsVisibility() {
        if isNew {
            title.accept("Settings.NewWord.TitleNew".localized())
            rightBarBtnCaption.accept("Settings.NewWord.RightBarBtnNew".localized())
        }
        else {
            title.accept("Settings.NewWord.TitleEdit".localized())
            rightBarBtnCaption.accept("Settings.NewWord.RightBarBtnSave".localized())
        }
    }
    
    func isRightBtnEnabled() -> Bool {
        guard let targetVal = target.value, let translateVal = translate.value else {
            return false
        }
        if targetVal.isEmpty || translateVal.isEmpty {
            return false
        }
            
        if isNew {
            return true
        }
        else {
            guard let word = learnedWord.word else {
                return false
            }
            return word.target != targetVal || word.translate != translateVal
        }
    }
}
