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
    case learnedWordNotFound
    case wordPairNotFound
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
    func addTopic(moduleId: String, topic: Topic) async throws
    func updateTopic(moduleId: String, topic: Topic) async throws // TODO: delete moduleId ?
    func deleteTopic(moduleId: String, topicId: String) async throws
    
    func learnedWord(id: String) async throws -> LearnedWord
    func addWord(topicId: String, word: LearnedWord) async throws
    func updateWord(topicId: String, word: LearnedWord) async throws
    func deleteWord(topicId: String, word: LearnedWord) async throws
    
    // WordPair
    func word(id: String) async throws -> WordPair
//    func addWord(learnedWordId: String, word: WordPair) async throws
//    func updateWord(learnedWordId: String, word: WordPair) async throws
    func addWord(_ word: WordPair) async throws
    func updateWord(_ word: WordPair) async throws
    
    func reset() async throws // delete all data. empty manager as result
}
