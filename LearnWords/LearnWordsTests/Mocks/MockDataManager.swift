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
    
//    var modules: [LearnWords.Module] = []
    
    private var storedModules: [Module] = []
    private var topics: [Topic] = []
    private var wordPairs: [WordPair] = []
    private var learnedWords: [LearnedWord] = []
    
    var modules: [ModulePreload] {
            get async throws {
//                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 секунда задержки
//                return storedModulesPreload
                let modulesPreload = storedModules.map{$0.modulePreload}
                return modulesPreload
            }
        }
    
    // MARK - DataManager
    func reset() async throws {
        storedModules = []
        topics = []
        wordPairs = []
        learnedWords = []
    }
    
    func module(id: String) async throws -> Module {
        log.method() // TODO
        
        guard let module = storedModules.first(where: { $0.id == id }) else {
            throw DataManagerError.moduleNotFound
        }
        return module
    }
    
    func addModule(_ module: Module) async throws {
        storedModules.append(module)
    }
    
    func updateModule(_ module: Module) async throws {
        log.method() // TODO
        guard let index = storedModules.firstIndex(where: {$0.id == module.id}) else {
            throw DataManagerError.moduleNotFound
        }
        storedModules[index] = module
    }
    
    func deleteModule(id: String) async throws {
        guard let moduleIndex = storedModules.firstIndex(where: {$0.id == id}) else {
            throw DataManagerError.updateDataError
        }
        storedModules.remove(at: moduleIndex)
    }
    
    // topics
    func topic(id: String) async throws -> Topic {
        guard let topic = topics.first(where: {$0.id == id}) else {
            throw DataManagerError.topicNotFound
        }
        return topic
    }
    
    /*
    fileprivate func topic(id: String) -> (Topic, Module)? {
        return nil // TODO:
//        for module in modules {
//            if let topic = module.topics.first(where: {$0.id == id}) {
//                return (topic, module)
//            }
//        }
//        return nil
    }
     */
    
    func addTopic(_ topic: Topic, moduleId: String?) async throws {
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
        log.method() // TODO
        
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
        log.method() // TODO
        
        topics.removeAll(where: {$0.id == id})
        
        // update in module if needed
        guard let moduleId = moduleId else {
            return
        }
        var module = try await module(id: moduleId)
        module.topics.removeAll(where: {$0.id == id})
        try await updateModule(module)
    }
    
    // LearnedWords
    
    func learnedWord(id: String) async throws -> LearnedWord {
        log.method() // TODO
        guard let learnedWord = learnedWords.first(where: {$0.id == id}) else {
            throw DataManagerError.learnedWordNotFound
        }
        return learnedWord
        
//        for module in modules {
//            for topic in module.topics {
//                guard let word = topic.words.first(where: {$0.id == id}) else {
//                    break
//                }
//                return word
//            }
//        }
//        
//        return nil
    }
    
    func addWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method() // TODO
        
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
        
        
//        guard var (topic, module) = topic(id: topicId) else {
//            return nil
//        }
//        
//        topic.words.append(word)
//        _ = updateTopic(moduleId: module.id, topic: topic)
//        
//        return topic
    }
    
    func updateWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method() // TODO
        
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
        
//        guard var (topic, module) = topic(id: topicId) else {
//            return nil
//        }
//        
//        guard let index = topic.words.firstIndex(where: {$0.id == word.id}) else {
//            return nil
//        }
//        topic.words[index] = word
//        
//        _ = updateTopic(moduleId: module.id, topic: topic)
//        
//        return topic
    }
    
    func deleteWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method() // TODO
        
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
        
//        guard var (topic, module) = topic(id: topicId) else {
//            return nil
//        }
//        
//        guard let index = topic.words.firstIndex(where: {$0.id == word.id}) else {
//            return nil
//        }
//        topic.words.remove(at: index)
//        
//        _ = updateTopic(moduleId: module.id, topic: topic)
//        
//        return topic
    }
    
    //WordPair
    
    func word(id: String) async throws -> WordPair {
        log.method() // TODO
        guard let word = wordPairs.first(where: {$0.id == id}) else {
            throw DataManagerError.wordPairNotFound
        }
        return word
//        for module in modules {
//            for topic in module.topics {
//                for learnedWord in topic.words {
//                    if learnedWord.word.id == id {
//                        return learnedWord.word
//                    }
//                }
//            }
//        }
//        
//        return nil
    }
    
//    func addWord(learnedWordId: String, word: WordPair) async throws {
    func addWord(_ word: WordPair) async throws {
        log.method()
        
        wordPairs.append(word)
    }
    
//    func updateWord(learnedWordId: String, word: WordPair) async throws {
    func updateWord(_ word: WordPair) async throws {
        log.method() // TODO
        
        guard let index = wordPairs.firstIndex(where: {$0.id == word.id}) else {
            throw DataManagerError.wordPairNotFound
        }
        wordPairs[index] = word
        
//        for module in modules {
//            for topic in module.topics {
//                for learnedWord in topic.words {
//                    if learnedWord.id == learnedWordId {
//                        var workWord = learnedWord
//                        workWord.word = word
//                        if( updateWord(topicId: topic.id, word: workWord) != nil ) {
//                            return learnedWord
//                        }
//                        else {
//                            return nil
//                        }
//                    }
//                }
//            }
//        }
//        return nil
    }
}
