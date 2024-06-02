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
    
    var modules: [ModulePreload] {
        get async throws {
            let ref = referenceFor(.modulePreloads)
            let snapshot = try await ref.getData()
            let obj = try anyObject(snapshot: snapshot)
            let modules = try JSONDecoder().decode([ModulePreload].self, from: obj)
            return modules
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
        
        try await addModuleFirebase(module)
        
        let modulePreload = module.modulePreload
        try await addModulePreloadFirebase(modulePreload)
    }
    
    private func addModuleFirebase(_ module: Module) async throws {
        let ref = referenceFor(.modules)
        let object = try jsonObject(model: module)
                
        try await ref.child(module.id).setValue(object)
    }
    
    private func addModulePreloadFirebase(_ module: ModulePreload) async throws {
        let ref = referenceFor(.modulePreloads)
        let object = try jsonObject(model: module)
                
        try await ref.child(module.id).setValue(object)
    }
    
    func updateModule(_ module: Module) async throws {
        log.method()
        
        try await updateModuleFirebase(module)
        
        let modulePreload = module.modulePreload
        try await updateModulePreloadFirebase(modulePreload)
    }
    
    private func updateModuleFirebase(_ module: Module) async throws {
        let ref = referenceFor(.modules).child(module.id)
        let object = try jsonObject(model: module)
        try await ref.updateChildValues(object as! [AnyHashable : Any])
    }
    
    private func updateModulePreloadFirebase(_ module: ModulePreload) async throws {
        let ref = referenceFor(.modulePreloads).child(module.id)
        let object = try jsonObject(model: module)
        try await ref.updateChildValues(object as! [AnyHashable : Any])
    }
    
    func deleteModule(id: String) async throws {
        log.method()
        
        try await deleteModuleFirebase(id: id)
        try await deleteModulePreloadFirebase(id: id)
    }
    
    func deleteModuleFirebase(id: String) async throws {
        let ref = referenceFor(.modules).child(id)
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

