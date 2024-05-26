//
//  MockDataManager.swift
//  LearnWordsTests
//
//  Created by sergemi on 11.04.2024.
//

import Foundation
//@testable import LearnWords

//class MockDataManager: DataManager {
final actor MockDataManager: DataManager {
    static let instance = MockDataManager()
    private init() {
    }
    
//    var modules: [LearnWords.Module] = []
    
    private var storedModules: [Module] = []
    private var topics: [Topic] = []
    
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
    }
    
    func module(id: String) async throws -> Module {
        log.method() // TODO
        
        guard let module = storedModules.first(where: { $0.id == id }) else {
            throw DataManagerError.moduleNotFound
        }
//        let topics = [Topic]() // todo
        
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
        log.method() // TODO
        return Topic() // todo
//        guard let preloadTopic = topicsPreload.first(where: {$0.id == id}) else {
//            throw DataManagerError.topicNotFound
//        }
//        
//        let words = [LearnedWord]() // todo
//        return Topic(topicPreload: preloadTopic, words: words)
        
//        for module in modules {
//            if let topic = module.topics.first(where: {$0.id == id}) {
//                return topic
//            }
//        }
//        
//        return nil
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
    
    func addTopic(moduleId: String, topic: Topic) async throws {
        var module = try await module(id: moduleId)
        module.topics.append(topic.topicPreload)
        try await updateModule(module)
        
        topics.append(topic)
    }
    
    func updateTopic(moduleId: String, topic: Topic) async throws {
        log.method() // TODO
        
//        guard var module = module(id: moduleId) else {
//            return nil
//        }
//        
//        guard let topicIndex = module.topics.firstIndex(where: {$0.id == topic.id}) else {
//            return nil
//        }
//        
//        module.topics[topicIndex] = topic
//        _ = updateModule(module)
//        
//        return module
    }
    func deleteTopic(moduleId: String, topicId: String) async throws {
        log.method() // TODO
        
        var module = try await module(id: moduleId)
        module.topics.removeAll(where: {$0.id == topicId})
        try await updateModule(module)
        
        topics.removeAll(where: {$0.id == topicId})
    }
    
    // LearnedWords
    
    func learnedWord(id: String) async throws -> LearnedWord {
        log.method() // TODO
        return LearnedWord()
        
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
    
    func addWord(topicId: String, word: LearnedWord) async throws {
        log.method() // TODO
        
//        guard var (topic, module) = topic(id: topicId) else {
//            return nil
//        }
//        
//        topic.words.append(word)
//        _ = updateTopic(moduleId: module.id, topic: topic)
//        
//        return topic
    }
    
    func updateWord(topicId: String, word: LearnedWord) async throws {
        log.method() // TODO
        
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
    
    func deleteWord(topicId: String, word: LearnedWord) async throws {
        log.method() // TODO
        
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
        return WordPair()
        
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
    
    func updateWord(learnedWordId: String, word: WordPair) async throws {
        log.method() // TODO
        
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
