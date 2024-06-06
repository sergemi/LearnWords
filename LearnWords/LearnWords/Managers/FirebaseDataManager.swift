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
    
    private enum DbKeys: String {
        case modules = "modules"
        case modulePreloads = "modulePreloads"
        case topics = "topics"
        case wordPairs = "wordPairs"
        case learnedWords = "learnedWords"
    }
    
    init(basePaht: String) {
        baseRef = Database.database().reference(withPath: basePaht)
        log.method()
    }
    // MARK: - DataManager
    
    var modules: [ModulePreload] {
        get async throws {
            let ref = referenceFor(.modulePreloads)
            let snapshot = try await ref.getData()
            if !snapshot.exists() {
                return []
            }
            let obj = try anyObject(snapshot: snapshot)
            let modules = try JSONDecoder().decode([ModulePreload].self, from: obj)
            return modules.sorted{$0.id < $1.id}
        }
    }
    
    func module(id: String) async throws -> Module {
        log.method()
        let ref = referenceFor(.modules).child(id)
        
        let snapshot = try await ref.getData()
        guard snapshot.exists(),
              let value = snapshot.value as? [String: Any] else {
            throw DataManagerError.moduleNotFound
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
        let module = try JSONDecoder().decode(Module.self, from: jsonData)
        
        return module
    }
    
    func addModule(_ module: Module) async throws {
        log.method()
        
        try await updateModuleFirebase(module)
        
        let modulePreload = module.modulePreload
        try await updateModulePreloadFirebase(modulePreload)
    }
    
    func updateModule(_ module: Module) async throws {
        log.method()
        // check if module exist
        _ = try await self.module(id: module.id)
                
        try await updateModuleFirebase(module)
        
        let modulePreload = module.modulePreload
        try await updateModulePreloadFirebase(modulePreload)
    }
    
    func deleteModule(id: String) async throws {
        log.method()
        
        // check if module exist
        _ = try await module(id: id)
        
        try await deleteModuleFirebase(id: id)
        try await deleteModulePreloadFirebase(id: id)
    }
    
    func topic(id: String) async throws -> Topic {
        log.method()
        
        let ref = referenceFor(.topics).child(id)
        
        let snapshot = try await ref.getData()
        guard snapshot.exists(),
              let value = snapshot.value as? [String: Any] else {
            throw DataManagerError.topicNotFound
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
        let topic = try JSONDecoder().decode(Topic.self, from: jsonData)
        
        return topic
    }
    
    func addTopic(_ topic: Topic, moduleId: String?) async throws {
        log.method()
        
        try await updateTopicFirebase(topic)
        try await updateTopicInModuleFirebase(topic: topic.topicPreload, moduleId: moduleId)
    }
    
    func updateTopic(_ topic: Topic, moduleId: String?) async throws {
        log.method()
        
        // check if topic exist
        _ = try await self.topic(id: topic.id)
        
        try await updateTopicFirebase(topic)
        try await updateTopicInModuleFirebase(topic: topic.topicPreload, moduleId: moduleId)
    }
    
    func deleteTopic(id: String, moduleId: String?) async throws {
        log.method()
        
        // check if topic exist
        _ = try await self.topic(id: id)
        
        if let moduleId = moduleId {
            try await deleteTopicFromModuleFirebase(topicId: id, moduleId: moduleId)
        }
        try await deleteTopicFirebase(id: id)
    }
    
    func learnedWord(id: String) async throws -> LearnedWord {
        log.method()
        
        let ref = referenceFor(.learnedWords).child(id)
        
        let snapshot = try await ref.getData()
        guard snapshot.exists(),
              let value = snapshot.value as? [String: Any] else {
            throw DataManagerError.learnedWordNotFound
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
        let learnedWord = try JSONDecoder().decode(LearnedWord.self, from: jsonData)
        
        return learnedWord
    }
    
    func addWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        
        try await updateLearnedWordFirebase(word)
        try await updateLearnedWordInTopicFirebase(word, topicId: topicId)
    }
    
    func updateWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        
        // test if word exist
        _ = try await learnedWord(id:word.id)
        
        try await updateLearnedWordFirebase(word)
        try await updateLearnedWordInTopicFirebase(word, topicId: topicId)
    }
    
    func deleteWord(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        
        // test if word exist
        _ = try await learnedWord(id:word.id)
        
        try await deleteLearnedWordFromTopicFirebase(word, topicId: topicId)
        try await deleteLearnedWordFirebase(word)
    }
    
    func word(id: String) async throws -> WordPair {
        log.method()
        
        let ref = referenceFor(.wordPairs).child(id)
        
        let snapshot = try await ref.getData()
        guard snapshot.exists(),
              let value = snapshot.value as? [String: Any] else {
            throw DataManagerError.topicNotFound
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
        let wordPair = try JSONDecoder().decode(WordPair.self, from: jsonData)
        
        return wordPair
    }
    
    func addWord(_ word: WordPair) async throws {
        log.method()
        
        try await updateWordFirebase(word)
    }
    
    func updateWord(_ word: WordPair) async throws {
        log.method()
        
        // check if word exist
        _ = try await self.word(id: word.id)
        
        try await updateWordFirebase(word)
    }
    
    func reset() async throws {
        log.method()
        
        try await baseRef.runTransactionBlock { currentData in
            if currentData.value != nil {
                currentData.value = nil
                
                return TransactionResult.success(withValue: currentData)
            } else {
                return TransactionResult.abort()
            }
        }
    }
    
    // MARK: - Private Data functions
    private func updateModuleFirebase(_ module: Module) async throws {
        let ref = referenceFor(.modules).child(module.id)
        var transactionError: Error?
        
        try await ref.runTransactionBlock { currentData in
            do {
                let jsonData = try JSONEncoder().encode(module)
                let dict: [String: Any] = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] ?? [:]
                currentData.value = dict
                            return TransactionResult.success(withValue: currentData)
            } catch {
                transactionError = error
                return TransactionResult.abort()
            }
        }
        
        if let error = transactionError {
            throw error
        }
        
//        let object = try jsonObject(model: module)
//        try await ref.updateChildValues(object as! [AnyHashable : Any])
    }
    
    private func updateModulePreloadFirebase(_ module: ModulePreload) async throws {
        let ref = referenceFor(.modulePreloads).child(module.id)
        var transactionError: Error?
        
        try await ref.runTransactionBlock { currentData in
            do {
                let jsonData = try JSONEncoder().encode(module)
                let moduleDict: [String: Any] = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] ?? [:]
                currentData.value = moduleDict
                            return TransactionResult.success(withValue: currentData)
            } catch {
                transactionError = error
                return TransactionResult.abort()
            }
        }
        if let error = transactionError {
            throw error
        }
//        let object = try jsonObject(model: module)
//        try await ref.updateChildValues(object as! [AnyHashable : Any])
    }
    
    func deleteModuleFirebase(id: String) async throws {
        let ref = referenceFor(.modules).child(id)
        var transactionError: Error?
        
        // TODO: if we try delete module wich not exist function don't throw 'moduleNotFound' esception. Also need check when firebase add async/await syntax for transactions
        try await ref.runTransactionBlock { currentData in
            //
            
            //
            
            
            if currentData.value != nil {
//            if !(currentData.value is NSNull) {
                currentData.value = nil
                
                return TransactionResult.success(withValue: currentData)
            } else {
                transactionError = DataManagerError.moduleNotFound
                return TransactionResult.abort()
            }
             
        }
        if let error = transactionError {
            throw error
        }
    }
    
    func deleteModulePreloadFirebase(id: String) async throws {
        let ref = referenceFor(.modulePreloads).child(id)
//        try await ref.removeValue()
        
        try await ref.runTransactionBlock { currentData in
            if currentData.value != nil {
                currentData.value = nil
                
                return TransactionResult.success(withValue: currentData)
            } else {
                return TransactionResult.abort()
            }
        }
    }
    
    private func updateTopicFirebase(_ topic: Topic) async throws {
        log.method()
        
        let ref = referenceFor(.topics).child(topic.id)
        var transactionError: Error?
        
        try await ref.runTransactionBlock { currentData in
            do {
                let jsonData = try JSONEncoder().encode(topic)
                let dict: [String: Any] = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] ?? [:]
                currentData.value = dict
                            return TransactionResult.success(withValue: currentData)
            } catch {
                transactionError = error
                return TransactionResult.abort()
            }
        }
        if let error = transactionError {
            throw error
        }
    }
    
    private func updateTopicInModuleFirebase(topic: TopicPreload, moduleId: String?) async throws {
        log.method()
        
        guard let moduleId = moduleId else {
            return
        }
        
        var module = try await module(id: moduleId)
        guard let index = module.topics.firstIndex(where: {$0.id == topic.id}) else {
            // add new topic
            module.topics.append(topic)
            try await updateModuleFirebase(module)
            return
        }
        // edit existing topic
        module.topics[index] = topic
        try await updateModuleFirebase(module)
    }
    
    private func deleteTopicFromModuleFirebase(topicId: String, moduleId: String) async throws {
        log.method()
        
        var module = try await module(id: moduleId)
        module.topics.removeAll(where: {$0.id == topicId})
        try await updateModule(module)
    }
    
    private func deleteTopicFirebase(id: String) async throws {
        log.method()
        
        let ref = referenceFor(.topics).child(id)
        
        try await ref.runTransactionBlock { currentData in
            if currentData.value != nil {
                currentData.value = nil
                
                return TransactionResult.success(withValue: currentData)
            } else {
                return TransactionResult.abort()
            }
        }
    }
    
    private func updateLearnedWordFirebase(_ word: LearnedWord) async throws {
        log.method()
        
        let ref = referenceFor(.learnedWords).child(word.id)
        var transactionError: Error?
        
        try await ref.runTransactionBlock { currentData in
            do {
                let jsonData = try JSONEncoder().encode(word)
                let dict: [String: Any] = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] ?? [:]
                currentData.value = dict
                            return TransactionResult.success(withValue: currentData)
            } catch {
                transactionError = error
                return TransactionResult.abort()
            }
        }
        if let error = transactionError {
            throw error
        }
    }
    
    private func updateLearnedWordInTopicFirebase(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        
        guard let topicId = topicId else {
            return
        }
        
        var topic = try await topic(id: topicId)
        guard let index = topic.words.firstIndex(where: {$0.id == word.id}) else {
            // add new topic
            topic.words.append(word)
            try await updateTopicFirebase(topic)
            return
        }
        // edit existing topic
        topic.words[index] = word
        try await updateTopicFirebase(topic)
    }
    
    private func deleteLearnedWordFromTopicFirebase(_ word: LearnedWord, topicId: String?) async throws {
        log.method()
        
        guard let topicId = topicId else {
            return
        }
        
        var topic = try await topic(id: topicId)
        guard let index = topic.words.firstIndex(where: {$0.id == word.id}) else {
            return
        }
        // edit existing topic
        topic.words.remove(at: index)
        try await updateTopicFirebase(topic)
    }
    
    private func deleteLearnedWordFirebase(_ word: LearnedWord) async throws {
        log.method()
        
        let ref = referenceFor(.learnedWords).child(word.id)
        
        try await ref.runTransactionBlock { currentData in
            if currentData.value != nil {
                currentData.value = nil
                
                return TransactionResult.success(withValue: currentData)
            } else {
                return TransactionResult.abort()
            }
        }
    }
    
    private func updateWordFirebase(_ word: WordPair) async throws {
        log.method()
        
        let ref = referenceFor(.wordPairs).child(word.id)
        var transactionError: Error?
        
        try await ref.runTransactionBlock { currentData in
            do {
                let jsonData = try JSONEncoder().encode(word)
                let dict: [String: Any] = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] ?? [:]
                currentData.value = dict
                            return TransactionResult.success(withValue: currentData)
            } catch {
                transactionError = error
                return TransactionResult.abort()
            }
        }
        if let error = transactionError {
            throw error
        }
    }
    
    // MARK: - Private service functions
    
    private func referenceFor(_ key: DbKeys) -> DatabaseReference {
        return baseRef.child(key.rawValue)
    }
    
    private func jsonObject(model: Codable) throws -> Any {
        let jsonData = try JSONEncoder().encode(model)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return jsonObject
    }
    
    private func anyObject(snapshot: DataSnapshot) throws -> Data {
        guard let value = snapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data format is invalid"])
            }
        
        let jsonData = try JSONSerialization.data(withJSONObject: Array(value.values), options: [])
        
        return jsonData
    }
}

