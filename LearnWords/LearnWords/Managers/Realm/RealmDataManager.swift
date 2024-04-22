//
//  RealmDataManager.swift
//  LearnWords
//
//  Created by sergemi on 14.04.2024.
//

import Foundation
import RealmSwift

class RealmDataManager: DataManager {
    var modules: [Module] {
        let realm = try! Realm()
        let realmModules = realm.objects(ModelModule_realm.self)
        
        return realmModules.map{$0.module}
        
    }
    
    func reset() {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.delete(realm.objects(ModelLearnedWord_realm.self))
                realm.delete(realm.objects(ModelTopic_realm.self))
                realm.delete(realm.objects(ModelModule_realm.self))
                realm.delete(realm.objects(ModelWordPair_realm.self))
            }
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
        }
    }
    
    func module(id: String) -> Module? {
        do {
            let realm = try Realm()
            
            guard let moduleRealm = realm.object(ofType: ModelModule_realm.self, forPrimaryKey: id) else {
                return nil
            }
            return moduleRealm.module
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func addModule(_ module: Module) -> Module? {
        let realmModule = ModelModule_realm(module: module)
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(realmModule)
            }
            
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
            
        return module
    }
    
    func updateModule(_ module: Module) -> Module? {
        do {
            let realm = try Realm()
//            guard let moduleRealm = realm.object(ofType: ModelModule_realm.self, forPrimaryKey: module.id) else {
//                return nil
//            }
            
            guard let moduleRealm = getRealmObject(realm: realm, objectType: ModelModule_realm.self, id: module.id) else {
                return nil
            }
            
            try realm.write {
                moduleRealm.updateFrom(module)
            }
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
        
        return module
    }
    
    func deleteModule(_ module: Module) -> Module? {
        do {
            let realm = try Realm()
            
            guard let moduleRealm = realm.object(ofType: ModelModule_realm.self, forPrimaryKey: module.id) else {
                return nil
            }
            
            try realm.write {
                realm.delete(moduleRealm)
            }
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
        return module
    }
    
    func topic(id: String) -> Topic? {
        do {
            let realm = try Realm()
            
            guard let topicRealm = realm.object(ofType: ModelTopic_realm.self, forPrimaryKey: id) else {
                return nil
            }
            return topicRealm.topic
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func addTopic(moduleId: String, topic: Topic) -> Module? {
        let topicRealm = ModelTopic_realm(topic: topic)
        do {
            let realm = try Realm()
//            guard let moduleRealm = realm.object(ofType: ModelModule_realm.self, forPrimaryKey: moduleId) else {
//                return nil
//            }
            guard let moduleRealm = getRealmObject(realm: realm, objectType: ModelModule_realm.self, id: moduleId) else {
                return nil
            }
            
            try realm.write {
                moduleRealm.topics.append(topicRealm)
            }
            return moduleRealm.module
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func updateTopic(moduleId: String, topic: Topic) -> Module? {
        do {
            let realm = try Realm()
            
            guard let moduleRealm = getRealmObject(realm: realm, objectType: ModelModule_realm.self, id: moduleId) else {
                return nil
            }
            
            guard let realmTopic = moduleRealm.topics.first(where: {$0.id == topic.id}) else {
                return nil
            }
            
            try realm.write {
                realmTopic.updateFrom(topic: topic)
            }
            
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
        return nil // TODO: implement
    }
    
    func deleteTopic(moduleId: String, topic: Topic) -> Module? {
        do {
            let realm = try Realm()
            guard let moduleRealm = realm.object(ofType: ModelModule_realm.self, forPrimaryKey: moduleId) else {
                return nil
            }
            
            guard let index = moduleRealm.topics.firstIndex(where: {$0.id == topic.id}) else {
                return nil
            }
            
            guard var realmTopic = moduleRealm.topics.first(where: {$0.id == topic.id}) else {
                return nil
            }
            
            try realm.write {
                moduleRealm.topics.remove(at: index)
                realm.delete(realmTopic)
            }
//            try realm.write {
//                realm.delete(realmTopic)
//            }
            
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
        return nil // TODO: implement
    }
    
    func learnedWord(id: String) -> LearnedWord? {
        do {
            let realm = try Realm()
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
        return nil // TODO: implement
    }
    
    func addWord(topicId: String, word: LearnedWord) -> Topic? {
        do {
            let realm = try Realm()
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
        return nil // TODO: implement
    }
    
    func updateWord(topicId: String, word: LearnedWord) -> Topic? {
        do {
            let realm = try Realm()
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
        return nil // TODO: implement
    }
    
    func deleteWord(topicId: String, word: LearnedWord) -> Topic? {
        do {
            let realm = try Realm()
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
        return nil // TODO: implement
    }
    
    func word(id: String) -> WordPair? {
        do {
            let realm = try Realm()
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
        return nil // TODO: implement
    }
    
    func updateWord(learnedWordId: String, word: WordPair) -> LearnedWord? {
        do {
            let realm = try Realm()
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return nil
        }
        return nil // TODO: implement
    }
    
    
}
