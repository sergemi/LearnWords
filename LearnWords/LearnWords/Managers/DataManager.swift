//
//  DataManager.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

protocol DataManager {
    var modules: [Module] {get}
    
    func reset() // delete all data. empty manager as result
    
    func module(id: String) -> Module? // nil if not found
    func addModule(_ module: Module) -> Module? // nil if fail
    func updateModule(_ module: Module) -> Module? // nil if fail
    func deleteModule(_ module: Module) -> Module? // nil if fail
    
//    var topics: [Topic] {get}
//    
    func topic(id: String) -> Topic? // nil if not found
    func addTopic(moduleId: String, topic: Topic) -> Module? // nil if fail
    func updateTopic(moduleId: String, topic: Topic) -> Module? // nil if fail
    func deleteTopic(moduleId: String, topic: Topic) -> Module? // nil if fail
    
    func learnedWord(id: String) -> LearnedWord?
    func addWord(topicId: String, word: LearnedWord) -> Topic?
    func updateWord(topicId: String, word: LearnedWord) -> Topic?
    func deleteWord(topicId: String, word: LearnedWord) -> Topic?
    
    func word(id: String) -> WordPair?
    func updateWord(learnedWordId: String, word: WordPair) -> LearnedWord?
}
