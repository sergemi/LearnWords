//
//  RealmDataManager.swift
//  LearnWords
//
//  Created by sergemi on 14.04.2024.
//

import Foundation
import RealmSwift

class RealmDataManager: DataManager {
    var modules: [Module] = []
    
    func module(id: String) -> Module? {
        return nil // TODO: implement
    }
    
    func addModule(_ module: Module) -> Module? {
        return nil // TODO: implement
    }
    
    func updateModule(_ module: Module) -> Module? {
        return nil // TODO: implement
    }
    
    func deleteModule(_ module: Module) -> Module? {
        return nil // TODO: implement
    }
    
    func topic(id: String) -> Topic? {
        return nil // TODO: implement
    }
    
    func addTopic(moduleId: String, topic: Topic) -> Module? {
        return nil // TODO: implement
    }
    
    func updateTopic(moduleId: String, topic: Topic) -> Module? {
        return nil // TODO: implement
    }
    
    func deleteTopic(moduleId: String, topic: Topic) -> Module? {
        return nil // TODO: implement
    }
    
    func learnedWord(id: String) -> LearnedWord? {
        return nil // TODO: implement
    }
    
    func addWord(topicId: String, word: LearnedWord) -> Topic? {
        return nil // TODO: implement
    }
    
    func updateWord(topicId: String, word: LearnedWord) -> Topic? {
        return nil // TODO: implement
    }
    
    func deleteWord(topicId: String, word: LearnedWord) -> Topic? {
        return nil // TODO: implement
    }
    
    func word(id: String) -> WordPair? {
        return nil // TODO: implement
    }
    
    func updateWord(learnedWordId: String, word: WordPair) -> LearnedWord? {
        return nil // TODO: implement
    }
    
    
}
