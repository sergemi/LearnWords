//
//  MockDataManager.swift
//  LearnWordsTests
//
//  Created by sergemi on 11.04.2024.
//

import Foundation
//@testable import LearnWords

//class MockDataManager: DataManager {
actor MockDataManager: DataManager {
    static let instance = MockDataManager()
    
//    var modules: [LearnWords.Module] = []
    
    private var storedModulesPreload: [ModulePreload] = []
    private var storedTopicsPreload: [TopicPreload] = []
    
    var modules: [ModulePreload] {
            get async throws {
                log.method() // TODO
                
//                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 секунда задержки
//                return storedModulesPreload
                return [] // todo
            }
        }
    
    private init() {
        
    }
    
    // MARK - DataManager
    func reset() async throws {
        storedModulesPreload = []
    }
    
    func module(id: String) async throws -> Module {
        log.method() // TODO
        
//        guard let preloadModule = storedModulesPreload.first(where: { $0.id == id }) else {
//            throw DataManagerError.moduleNotFound
//        }
//        let topics = [Topic]() // todo
//        
//        return Module(modulePreload: preloadModule, topics: topics)
        return Module() // todo
    }
    
    func addModule(_ module: Module) async throws {
        log.method() // TODO
//        storedModulesPreload.append(module.modulePreload)
    }
    
    func updateModule(_ module: Module) async throws {
        log.method() // TODO
//        guard let index = storedModulesPreload.firstIndex(where: {$0.id == module.id}) else {
//            throw DataManagerError.moduleNotFound
//        }
//        storedModulesPreload[index] = module.modulePreload
    }
    
    func deleteModule(id: String) async throws {
        log.method() // TODO
//        guard let moduleIndex = storedModulesPreload.firstIndex(where: {$0.id == id}) else {
//            throw DataManagerError.updateDataError
//        }
//        storedModulesPreload.remove(at: moduleIndex)
    }
    
    // topics
    func topic(id: String) async throws -> Topic {
        log.method() // TODO
        return Topic() // todo
//        guard let preloadTopic = storedTopicsPreload.first(where: {$0.id == id}) else {
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
        log.method() // TODO
        
        // storedModulesPreload
        /*
        var module = try await module(id: moduleId)
        module.topics.append(topic)
        try await updateModule(module)
//        storedTopicsPreload.append(topic) // todo
        
        log.method()
        
//        guard var module = module(id: moduleId) else {
//            return nil
//        }
//        
//        module.topics.append(topic)
//        _ = updateModule(module)
//        
//        return module
         */
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
    func deleteTopic(moduleId: String, topic: Topic) async throws {
        log.method() // TODO
        
//        guard var module = module(id: moduleId) else {
//            return nil
//        }
//        
//        guard let topicIndex = module.topics.firstIndex(where: {$0.id == topic.id}) else {
//            return nil
//        }
//        
//        module.topics.remove(at: topicIndex)
//        _ = updateModule(module)
//        
//        return module
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
