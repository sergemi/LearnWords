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
    
    private init() {
        
    }
    
    var modules: [LearnWords.Module] = []
    
    // MARK - DataManager
    func module(id: String) -> LearnWords.Module? {
        let module = modules.first{$0.id == id}
        return module
    }
    
    func addModule(_ module: LearnWords.Module) -> LearnWords.Module? {
        modules.append(module)
        return module
    }
    
    func updateModule(_ module: Module) -> LearnWords.Module? {
        guard let index = modules.firstIndex(where: {$0.id == module.id}) else {
            return nil
        }
        
        modules[index] = module
        return modules[index]
    }
    
    func deleteModule(_ module: Module) -> LearnWords.Module? {
        guard let index = modules.firstIndex(where: {$0.id == module.id}) else {
            return nil
        }
        return modules.remove(at: index)
    }
    
    // topics
    func topic(id: String) -> Topic? {
        for module in modules {
            if let topic = module.topics.first(where: {$0.id == id}) {
                return topic
            }
        }
        
        return nil
    }
    
    fileprivate func topic(id: String) -> (Topic, Module)? {
        for module in modules {
            if let topic = module.topics.first(where: {$0.id == id}) {
                return (topic, module)
            }
        }
        return nil
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
        for module in modules {
            for topic in module.topics {
                guard let word = topic.words.first(where: {$0.id == id}) else {
                    break
                }
                return word
            }
        }
        
        return nil
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
        for module in modules {
            for topic in module.topics {
                for learnedWord in topic.words {
                    if learnedWord.word.id == id {
                        return learnedWord.word
                    }
                }
            }
        }
        
        return nil
    }
    
    func updateWord(learnedWordId: String, word: WordPair) -> LearnedWord? {
        for module in modules {
            for topic in module.topics {
                for learnedWord in topic.words {
                    if learnedWord.id == learnedWordId {
                        var workWord = learnedWord
                        workWord.word = word
                        if( updateWord(topicId: topic.id, word: workWord) != nil ) {
                            return learnedWord
                        }
                        else {
                            return nil
                        }
                    }
                }
            }
        }
        return nil
    }
}
