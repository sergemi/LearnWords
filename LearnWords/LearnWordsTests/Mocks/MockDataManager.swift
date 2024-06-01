//
//  MockDataManager.swift
//  LearnWordsTests
//
//  Created by sergemi on 11.04.2024.
//

import Foundation
//@testable import LearnWords

final actor MockDataManager: DataManager {
    static let instance = MockDataManager()
    private init() {
    }
    
    private var storedModules: [Module] = []
    private var topics: [Topic] = []
    private var wordPairs: [WordPair] = []
    private var learnedWords: [LearnedWord] = []
    
    var modules: [ModulePreload] {
        get async throws {
            //            try? await Task.sleep(nanoseconds: 1_000_000_000)
            let modulesPreload = storedModules.map{$0.modulePreload}
            return modulesPreload
        }
    }
    
    // MARK - DataManager
    func reset() async throws {
        log.method()
        storedModules = []
        topics = []
        wordPairs = []
        learnedWords = []
    }
    
    func module(id: String) async throws -> Module {
        log.method()
        
        guard let module = storedModules.first(where: { $0.id == id }) else {
            throw DataManagerError.moduleNotFound
        }
        return module
    }
    
    func addModule(_ module: Module) async throws {
        log.method()
        storedModules.append(module)
    }
    
    func updateModule(_ module: Module) async throws {
        log.method()
        guard let index = storedModules.firstIndex(where: {$0.id == module.id}) else {
            throw DataManagerError.moduleNotFound
        }
        storedModules[index] = module
    }
    
    func deleteModule(id: String) async throws {
        log.method()
        guard let moduleIndex = storedModules.firstIndex(where: {$0.id == id}) else {
            throw DataManagerError.moduleNotFound
        }
        storedModules.remove(at: moduleIndex)
    }
    
    // topics
    func topic(id: String) async throws -> Topic {
        log.method()
        guard let topic = topics.first(where: {$0.id == id}) else {
            throw DataManagerError.topicNotFound
        }
        return topic
    }
    
    
    func addTopic(_ topic: Topic, moduleId: String?) async throws {
        log.method()
        topics.append(topic)
        
        // update in module if needed
        guard let moduleId = moduleId else {
            return
        }
        var module = try await module(id: moduleId)
        module.topics.append(topic.topicPreload)
        try await updateModule(module)
    }
    
    func updateTopic(_ topic: Topic, moduleId: String?) async throws {
        log.method()
        
        guard let index = topics.firstIndex(where: {$0.id == topic.id}) else {
            throw DataManagerError.topicNotFound
        }
        topics[index] = topic
        
        // update in module if needed
        guard let moduleId = moduleId else {
            return
        }
        var module = try await module(id: moduleId)
        guard let moduleTopicIndex = module.topics.firstIndex(where: {$0.id == topic.id}) else {
            throw DataManagerError.updateDataError
        }
        module.topics[moduleTopicIndex] = topic.topicPreload
        try await updateModule(module)
    }
    
    func deleteTopic(id: String, moduleId: String?) async throws {
        log.method()
        
        guard let index = topics.firstIndex(where: {$0.id == id}) else {
            throw DataManagerError.topicNotFound
        }
        topics.remove(at: index)
        
        // update in module if needed
        guard let moduleId = moduleId else {
            return
        }
        var module = try await module(id: moduleId)
        module.topics.removeAll(where: {$0.id == id})
        try await updateModule(module)
    }
    
    func learnedWord(id: String) async throws -> LearnedWord {
        log.method()
        guard let learnedWord = learnedWords.first(where: {$0.id == id}) else {
            throw DataManagerError.learnedWordNotFound
        }
        return learnedWord
    }
    
    func addWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        
        // add WordPair if it not already presented
        do {
            _ = try await self.word(id: word.word.id)
        }
        catch(DataManagerError.wordPairNotFound) {
            try await addWord(word.word)
        }
        learnedWords.append(word)
        // add to topic if need
        guard let topicId = topicId else {
            return
        }
        var topic = try await topic(id: topicId)
        topic.words.append(word)
        try await updateTopic(topic, moduleId: nil)
    }
    
    func updateWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        
        guard let index = learnedWords.firstIndex(where: {$0.id == word.id}) else {
            throw DataManagerError.learnedWordNotFound
        }
        learnedWords[index] = word
        
        // update in topic if need
        guard let topicId = topicId else {
            return
        }
        var topic = try await topic(id: topicId)
        guard let index = topic.words.firstIndex(where: {$0.id == word.id}) else {
            throw DataManagerError.updateDataError
        }
        topic.words[index] = word
        try await updateTopic(topic, moduleId: nil)
    }
    
    func deleteWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        
        guard let index = learnedWords.firstIndex(where: {$0.id == word.id}) else {
            throw DataManagerError.learnedWordNotFound
        }
        learnedWords.remove(at: index)
        
        // update in topic if need
        guard let topicId = topicId else {
            return
        }
        var topic = try await topic(id: topicId)
        guard let index = topic.words.firstIndex(where: {$0.id == word.id}) else {
            throw DataManagerError.updateDataError
        }
        topic.words.remove(at: index)
        try await updateTopic(topic, moduleId: nil)
    }
    
    //WordPair
    
    func word(id: String) async throws -> WordPair {
        log.method()
        guard let word = wordPairs.first(where: {$0.id == id}) else {
            throw DataManagerError.wordPairNotFound
        }
        return word
    }
    
    func addWord(_ word: WordPair) async throws {
        log.method()
        
        wordPairs.append(word)
    }
    
    func updateWord(_ word: WordPair) async throws {
        log.method()
        
        guard let index = wordPairs.firstIndex(where: {$0.id == word.id}) else {
            throw DataManagerError.wordPairNotFound
        }
        wordPairs[index] = word
    }
}
