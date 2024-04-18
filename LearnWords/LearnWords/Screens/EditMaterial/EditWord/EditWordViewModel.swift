//
//  EditWordViewModel.swift
//  LearnWords
//
//  Created by sergemi on 23.02.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class EditWordViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    var coordinator: EditMaterialCoordinatorProtocol? = nil
    let dataManager: DataManager!
    
    var isNew = true
    var topic: Topic
    var learnedWord: LearnedWord
    
    let title = BehaviorRelay<String?>(value: "")
    let rightBarBtnCaption = BehaviorRelay<String?>(value: "Add")
    let haveRightBarBtn = BehaviorRelay<Bool>(value: true)
    let rightBtnObserver = PublishSubject<Void>()
    
    let target = BehaviorRelay<String?>(value: "")
    let pronounce = BehaviorRelay<String?>(value: "")
    let translate = BehaviorRelay<String?>(value: "")
    let notes = BehaviorRelay<String?>(value: "")
    
    init(dataManager: DataManager, topic: Topic, learnedWord: LearnedWord, isNew: Bool = false) {
        self.dataManager = dataManager
        self.topic = topic
        self.learnedWord = learnedWord
        self.isNew = isNew
        
        bind()
        UpdateButtonsVisibility()
        
        let wordPair = learnedWord.word
        target.accept(wordPair.target)
        pronounce.accept(wordPair.pronounce)
        translate.accept(wordPair.translate)
        notes.accept(wordPair.notes)
    }
    
    convenience init(dataManager: DataManager, topic: Topic) {
        self.init(dataManager: dataManager, topic: topic,
                  learnedWord: LearnedWord(word: WordPair(target: "",
                                                          translate: "",
                                                          pronounce: "",
                                                          notes: ""),
                                           exercises: []),
                  isNew: true)
    }
    
    fileprivate func bind() {
        _ = rightBtnObserver.bind(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            print("++ Save word ++")
            print("target: \(String(describing: (self.target.value) ?? ""))")
            print("translate: \(String(describing: (self.translate.value) ?? ""))")
            self.learnedWord.word.target = self.target.value ?? ""
            self.learnedWord.word.pronounce = self.pronounce.value ?? ""
            self.learnedWord.word.notes = self.notes.value ?? ""
            self.learnedWord.word.translate = self.translate.value ?? ""
            if self.isNew {
                let res = self.dataManager.addWord(topicId: self.topic.id, word: self.learnedWord)
                // TODO: show error
                print(res)
            }
            else {
                let res = self.dataManager.updateWord(topicId: self.topic.id, word: self.learnedWord)
                // TODO: show error
                print(res)
            }
            self.isNew = false
            self.UpdateButtonsVisibility()
            self.haveRightBarBtn.accept(self.isRightBtnEnabled())
            
            //TODO:
//            let realm = try! Realm()
//            try! realm.write {
//                if self.learnedWord.word == nil {
//                    self.learnedWord.word = ModelWordPair_realm()
//                }
//                self.learnedWord.word?.target = self.target.value ?? ""
//                self.learnedWord.word?.pronounce = self.pronounce.value ?? ""
//                self.learnedWord.word?.notes = self.notes.value ?? ""
//                self.learnedWord.word?.translate = self.translate.value ?? ""
//                if self.isNew {
//                    self.topic.words.append(self.learnedWord)
//                }
//                self.isNew = false
//                self.UpdateButtonsVisibility()
//                self.haveRightBarBtn.accept(self.isRightBtnEnabled())
//            }
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
            let word = learnedWord.word
            return word.target != targetVal || word.translate != translateVal || word.pronounce != pronounce.value || word.notes != notes.value
        }
    }
}
