//
//  FirebaseDataManager.swift
//  LearnWords
//
//  Created by sergemi on 25.04.2024.
//

import Foundation
import FirebaseDatabase

final actor FirebaseDataManager: DataManager {
    private let baseRef: DatabaseReference
    
    private enum dbKeys {
        static let modules = "modules"
        static let topics = "topics"
        static let wordPairs = "wordPairs"
        static let learnedWords = "learnedWords"
    }
    
    init(basePaht: String) {
        baseRef = Database.database().reference(withPath: basePaht)
        log.method()
    }
    
    var modules: [ModulePreload] {
        return [] // TODO: implement
    }
    
    func module(id: String) async throws -> Module {
        log.method()
        return Module() // TODO: implement
    }
    
    func addModule(_ module: Module) async throws {
        log.method()
        // TODO: implement
    }
    
    func updateModule(_ module: Module) async throws {
        log.method()
        // TODO: implement
    }
    
    func deleteModule(id: String) async throws {
        log.method()
        // TODO: implement
    }
    
    func topic(id: String) async throws -> Topic {
        log.method()
        
        return Topic() // TODO: implement
    }
    
    func addTopic(_ topic: Topic, moduleId: String?) async throws {
        log.method()
        // TODO: implement
    }
    
    func updateTopic(_ topic: Topic, moduleId: String?) async throws {
        log.method()
        // TODO: implement
    }
    
    func deleteTopic(id: String, moduleId: String?) async throws {
        log.method()
        // TODO: implement
    }
    
    func learnedWord(id: String) async throws -> LearnedWord {
        log.method()
        
        return LearnedWord() // TODO: implement
    }
    
    func addWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        // TODO: implement
    }
    
    func updateWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        // TODO: implement
    }
    
    func deleteWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        // TODO: implement
    }
    
    func word(id: String) async throws -> WordPair {
        log.method()
        
        return WordPair() // TODO: implement
    }
    
    func addWord(_ word: WordPair) async throws {
        log.method()
        // TODO: implement
    }
    
    func updateWord(_ word: WordPair) async throws {
        log.method()
        // TODO: implement
    }
    
    func reset() async throws {
        log.method()
        // TODO: implement
    }
    
}

