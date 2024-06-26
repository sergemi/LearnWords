//
//  EditWordViewModel.swift
//  LearnWords
//
//  Created by sergemi on 23.02.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class EditWordViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private weak var coordinator: EditMaterialCoordinatorProtocol?
    private let dataManager: DataManager!
    
    var isNew = true
    private let topicId: String
    var learnedWord: LearnedWord?
    
    let title = BehaviorRelay<String?>(value: "")
    let rightBarBtnCaption = BehaviorRelay<String?>(value: "Add")
    let haveRightBarBtn = BehaviorRelay<Bool>(value: true)
    let rightBtnObserver = PublishSubject<Void>()
    
    let target = BehaviorRelay<String?>(value: "")
    let pronounce = BehaviorRelay<String?>(value: "")
    let translate = BehaviorRelay<String?>(value: "")
    let notes = BehaviorRelay<String?>(value: "")
    
    init(dataManager: DataManager, coordinator: EditMaterialCoordinatorProtocol?, topicId: String, learnedWord: LearnedWord? = nil) {
        self.dataManager = dataManager
        self.coordinator = coordinator
        self.topicId = topicId
        self.learnedWord = learnedWord
        self.isNew = learnedWord == nil
        
        bind()
        UpdateButtonsVisibility()
        
        if let learnedWord = learnedWord {
            updateUiFrom(learnedWord: learnedWord)
        }
        else {
            self.learnedWord = LearnedWord()
        }
    }
    
    private func updateUiFrom(learnedWord: LearnedWord) {
        let wordPair = learnedWord.word
        target.accept(wordPair.target)
        pronounce.accept(wordPair.pronounce)
        translate.accept(wordPair.translate)
        notes.accept(wordPair.notes)
    }
    
    private func updateLearnedWordFromUi() {
        learnedWord?.word.target = self.target.value ?? ""
        learnedWord?.word.pronounce = self.pronounce.value ?? ""
        learnedWord?.word.notes = self.notes.value ?? ""
        learnedWord?.word.translate = self.translate.value ?? ""
    }
        
    fileprivate func bind() {
        _ = rightBtnObserver.bind(onNext: { [weak self] _ in
            log.method() // todo
            
            guard let self = self, let learnedWord = self.learnedWord else {
                return
            }
            print("++ Save word ++")
            print("target: \(String(describing: (self.target.value) ?? ""))")
            print("translate: \(String(describing: (self.translate.value) ?? ""))")
        
            updateLearnedWordFromUi()
            
            Task { [weak self] in
                guard let self = self, let learnedWord = self.learnedWord else {
                    return
                }
                do {
                    if self.isNew {
                        try await self.dataManager.addWord(learnedWord, topicId: self.topicId)
                        self.isNew = false
                        DispatchQueue.main.async {
                            self.UpdateButtonsVisibility()
                            self.haveRightBarBtn.accept(self.isRightBtnEnabled())
                        }
                    }
                    else {
                        try await self.dataManager.updateWord(learnedWord, topicId: self.topicId)
                        self.isNew = false
                        DispatchQueue.main.async {
                            self.UpdateButtonsVisibility()
                            self.haveRightBarBtn.accept(self.isRightBtnEnabled())
                        }
                    }
                }
                catch {
                    if let error = error as? LocalizedError {
                        print(error.localizedDescription)
                    } else {
                        print("An unexpected error occurred: \(error)")
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        _ = target.subscribe(onNext: { [weak self] value in
            guard let self = self else {
                return
            }
            self.haveRightBarBtn.accept(self.isRightBtnEnabled())
        }).disposed(by: disposeBag)
        
        _ = pronounce.subscribe(onNext: { [weak self] value in
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
        
        _ = notes.subscribe(onNext: { [weak self] value in
            guard let self = self else {
                return
            }
            self.haveRightBarBtn.accept(self.isRightBtnEnabled())
        }).disposed(by: disposeBag)
    }
    
    func UpdateButtonsVisibility() {
        if isNew {
            title.accept("Settings.EditWord.TitleNew".localized())
            rightBarBtnCaption.accept("Settings.EditWord.RightBarBtnNew".localized())
        }
        else {
            title.accept("Settings.EditWord.TitleEdit".localized())
            rightBarBtnCaption.accept("Settings.EditWord.RightBarBtnSave".localized())
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
            guard let word = learnedWord?.word else {
                return false
            }
            return word.target != targetVal || word.translate != translateVal || word.pronounce != pronounce.value || word.notes != notes.value
        }
    }
}
