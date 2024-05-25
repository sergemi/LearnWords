//
//  DataManager.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

//import RxSwift
//import RxCocoa

enum DataManagerError: Error, LocalizedError {
    case unknownError
    case moduleNotFound
    case topicNotFound
    case updateDataError
}

protocol DataManager {
//    var modules: [Module] {get}
//    var modules: BehaviorRelay<[ModulePreload]> {get}
    var modules: [ModulePreload] { get async throws }
    func module(id: String) async throws -> Module
    func addModule(_ module: Module) async throws
    func updateModule(_ module: Module) async throws
    func deleteModule(id: String) async throws
    
//    var topics: [Topic] {get}
//    
    func topic(id: String) async throws -> Topic
    func addTopic(moduleId: String, topic: Topic) -> Module? // nil if fail
    func updateTopic(moduleId: String, topic: Topic) -> Module? // nil if fail
    func deleteTopic(moduleId: String, topic: Topic) -> Module? // nil if fail
    
    func learnedWord(id: String) -> LearnedWord?
    func addWord(topicId: String, word: LearnedWord) -> Topic?
    func updateWord(topicId: String, word: LearnedWord) -> Topic?
    func deleteWord(topicId: String, word: LearnedWord) -> Topic?
    
    func word(id: String) -> WordPair?
    func updateWord(learnedWordId: String, word: WordPair) -> LearnedWord?
    
    func reset() async throws // delete all data. empty manager as result
}
