//
//  FirebaseDataManager.swift
//  LearnWords
//
//  Created by sergemi on 25.04.2024.
//

import Foundation
import FirebaseDatabase


class FirebaseDataManager: DataManager {
    private let baseRef: DatabaseReference
    
    private enum dbKeys {
        static let modules = "modules"
        static let topics = "topics"
    }
    
    init(basePaht: String) {
        baseRef = Database.database().reference(withPath: basePaht)
    }
    
    // MARK: - DataManager
    var modules: [Module] {
        let itemsRef = baseRef.child(dbKeys.modules)
        return []
    }
    
    func reset() {
        // TODO: implement
    }
    
    func module(id: String) -> Module? {
        // TODO: implement
        return nil
    }
    
    func addModule(_ module: Module) -> Module? {
        // TODO: implement
        return nil
    }
    
    func updateModule(_ module: Module) -> Module? {
        // TODO: implement
        return nil
    }
    
    func deleteModule(_ module: Module) -> Module? {
        // TODO: implement
        return nil
    }
    
    func topic(id: String) -> Topic? {
        // TODO: implement
        return nil
    }
    
    func addTopic(moduleId: String, topic: Topic) -> Module? {
        // TODO: implement
        return nil
    }
    
    func updateTopic(moduleId: String, topic: Topic) -> Module? {
        // TODO: implement
        return nil
    }
    
    func deleteTopic(moduleId: String, topic: Topic) -> Module? {
        // TODO: implement
        return nil
    }
    
    func learnedWord(id: String) -> LearnedWord? {
        // TODO: implement
        return nil
    }
    
    func addWord(topicId: String, word: LearnedWord) -> Topic? {
        // TODO: implement
        return nil
    }
    
    func updateWord(topicId: String, word: LearnedWord) -> Topic? {
        // TODO: implement
        return nil
    }
    
    func deleteWord(topicId: String, word: LearnedWord) -> Topic? {
        // TODO: implement
        return nil
    }
    
    func word(id: String) -> WordPair? {
        // TODO: implement
        return nil
    }
    
    func updateWord(learnedWordId: String, word: WordPair) -> LearnedWord? {
        // TODO: implement
        return nil
    }
    
    
}
