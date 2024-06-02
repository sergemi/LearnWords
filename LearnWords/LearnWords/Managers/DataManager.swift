//
//  DataManager.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

enum DataManagerError: Error, LocalizedError {
    case unknownError
    case moduleNotFound
    case topicNotFound
    case learnedWordNotFound
    case wordPairNotFound
    case updateDataError
}

protocol DataManager {
    var modules: [ModulePreload] { get async throws }
    func module(id: String) async throws -> Module
    func addModule(_ module: Module) async throws
    func updateModule(_ module: Module) async throws
    func deleteModule(id: String) async throws
      
    func topic(id: String) async throws -> Topic
    func addTopic(_ topic: Topic, moduleId: String?) async throws
    func updateTopic(_ topic: Topic, moduleId: String?) async throws
    func deleteTopic(id: String, moduleId: String?) async throws
    
    func learnedWord(id: String) async throws -> LearnedWord
    func addWord(_ word: LearnedWord, topicId: String?) async throws
    func updateWord(_ word: LearnedWord, topicId: String?) async throws
    func deleteWord(_ word: LearnedWord, topicId: String?) async throws
    
    // WordPair
    func word(id: String) async throws -> WordPair
    func addWord(_ word: WordPair) async throws
    func updateWord(_ word: WordPair) async throws
    
    func reset() async throws // delete all data. empty manager as result
}
