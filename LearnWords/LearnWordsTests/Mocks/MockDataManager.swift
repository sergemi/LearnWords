//
//  MockDataManager.swift
//  LearnWordsTests
//
//  Created by sergemi on 11.04.2024.
//

import Foundation
//@testable import LearnWords

class MockDataManager: DataManager {
    static let instance = MockDataManager()
    
//    var modules: [LearnWords.Module] = []
    
    private var storedModulesPreload: [ModulePreload] = []
    private var storedModules: [Module] = []
    
    var modules: [ModulePreload] {
            get async {
                // Асинхронная операция, например, загрузка данных
                // В данном случае просто задержка для имитации асинхронной работы
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 секунда задержки
                return storedModulesPreload
            }
        }
    
    private init() {
        
    }
    
    // MARK - DataManager
    func reset() {
        storedModulesPreload = []
        storedModules = []
    }
    
    func module(id: String) -> LearnWords.Module? {
        return nil // TODO:
//        let module = modules.first{$0.id == id}
//        return module
    }
    
    func addModule(_ module: LearnWords.Module) -> LearnWords.Module? {
        return nil // TODO:
        
//        modules.append(module)
//        return module
    }
    
    func updateModule(_ module: Module) -> LearnWords.Module? {
        return nil // TODO:
//        guard let index = modules.firstIndex(where: {$0.id == module.id}) else {
//            return nil
//        }
//        
//        modules[index] = module
//        return modules[index]
    }
    
    func deleteModule(_ module: Module) -> LearnWords.Module? {
        return nil // TODO:
//        guard let index = modules.firstIndex(where: {$0.id == module.id}) else {
//            return nil
//        }
//        return modules.remove(at: index)
    }
    
    // topics
    func topic(id: String) -> Topic? {
        return nil // TODO:
        
//        for module in modules {
//            if let topic = module.topics.first(where: {$0.id == id}) {
//                return topic
//            }
//        }
//        
//        return nil
    }
    
    fileprivate func topic(id: String) -> (Topic, Module)? {
        return nil // TODO:
//        for module in modules {
//            if let topic = module.topics.first(where: {$0.id == id}) {
//                return (topic, module)
//            }
//        }
//        return nil
    }
    
    func addTopic(moduleId: String, topic: Topic) -> Module? {
        guard var module = module(id: moduleId) else {
            return nil
        }
        
        module.topics.append(topic)
        _ = updateModule(module)
        
        return module
    }
    
    func updateTopic(moduleId: String, topic: Topic) -> Module? {
        guard var module = module(id: moduleId) else {
            return nil
        }
        
        guard let topicIndex = module.topics.firstIndex(where: {$0.id == topic.id}) else {
            return nil
        }
        
        module.topics[topicIndex] = topic
        _ = updateModule(module)
        
        return module
    }
    func deleteTopic(moduleId: String, topic: Topic) -> Module? {
        guard var module = module(id: moduleId) else {
            return nil
        }
        
        guard let topicIndex = module.topics.firstIndex(where: {$0.id == topic.id}) else {
            return nil
        }
        
        module.topics.remove(at: topicIndex)
        _ = updateModule(module)
        
        return module
    }
    
    // LearnedWords
    
    func learnedWord(id: String) -> LearnedWord? {
        return nil // TODO:
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
    
    func addWord(topicId: String, word: LearnedWord) -> Topic? {
        guard var (topic, module) = topic(id: topicId) else {
            return nil
        }
        
        topic.words.append(word)
        _ = updateTopic(moduleId: module.id, topic: topic)
        
        return topic
    }
    
    func updateWord(topicId: String, word: LearnedWord) -> Topic? {
        guard var (topic, module) = topic(id: topicId) else {
            return nil
        }
        
        guard let index = topic.words.firstIndex(where: {$0.id == word.id}) else {
            return nil
        }
        topic.words[index] = word
        
        _ = updateTopic(moduleId: module.id, topic: topic)
        
        return topic
    }
    
    func deleteWord(topicId: String, word: LearnedWord) -> Topic? {
        guard var (topic, module) = topic(id: topicId) else {
            return nil
        }
        
        guard let index = topic.words.firstIndex(where: {$0.id == word.id}) else {
            return nil
        }
        topic.words.remove(at: index)
        
        _ = updateTopic(moduleId: module.id, topic: topic)
        
        return topic
    }
    
    //WordPair
    
    func word(id: String) -> WordPair? {
        return nil // TODO:
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
    
    func updateWord(learnedWordId: String, word: WordPair) -> LearnedWord? {
        return nil // TODO:
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
