//
//  ModelModule_realm.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelModule_realm: RealmObjectWidthId {
    @Persisted var name: String = ""
    @Persisted var details: String = ""
    @Persisted var topics: List<ModelTopic_realm>
    @Persisted var author: String = ""
    @Persisted var isPublic: Bool = true
}

extension ModelModule_realm {
    func updateFrom(_ module: Module) {
        // TODO
//        name = module.name
//        details = module.details
//        author = module.author
//        isPublic = module.isPublic
//        
//        topics.removeAll()
//        var topicsArray : [ModelTopic_realm] = []
//        do {
//            let realm = try Realm()
//            
//            for topic in module.topics {
//                var realmTopic = getRealmObject(realm: realm,
//                                                   objectType: ModelTopic_realm.self,
//                                                   id: topic.id)
//                if realmTopic == nil {
//                    realmTopic = ModelTopic_realm(topic: topic)
//                }
//                topicsArray.append(realmTopic!)
//            }
//            
//        } catch let error as NSError {
//            print("Realm error: \(error.localizedDescription)")
//            return
//        }
//        
//        topics.append(objectsIn: topicsArray)
    }
    
    convenience init(module: Module) {
        self.init()
        id = module.id
        updateFrom(module)
    }
    
    var module: Module {
        // TODO
        return Module()
        
//        var newTopics = [Topic]()
//        for topic in topics {
//            let newTopic = topic.topic
//            newTopics.append(newTopic)
//        }
//        
//        let newModule = Module(id: id,
//                               name: name,
//                               details: details,
//                               topics: newTopics,
//                               author: author,
//                               isPublic: isPublic)
//        
//        return newModule
    }
}
