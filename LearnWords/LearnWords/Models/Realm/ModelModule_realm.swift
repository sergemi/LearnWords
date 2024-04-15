//
//  ModelModule_realm.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelModule_realm: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String = ""
    @Persisted var details: String = ""
    @Persisted var topics: List<ModelTopic_realm>
    @Persisted var author: String = ""
    @Persisted var isPublic: Bool = true
}

extension ModelModule_realm {
    convenience init(module: Module) {
        self.init()
        id = module.id
        name = module.name
        details = module.details
        author = module.author
        isPublic = module.isPublic
        
        let topicsArray = module.topics.map{ModelTopic_realm(topic: $0)}
        topics.append(objectsIn: topicsArray)
    }
    
    var module: Module {
        var newTopics = [Topic]()
        for topic in topics {
            let newTopic = topic.topic
            newTopics.append(newTopic)
        }
        
        var newModule = Module(id: id,
                               name: name,
                               details: details,
                               topics: newTopics,
                               author: author,
                               isPublic: isPublic)
        
        return newModule
    }
}
