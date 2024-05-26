//
//  Module.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

struct Module {
    let id: String
    
    var name: String
    var details: String
    var topics: [TopicPreload]
    var author: String // author id
    var isPublic: Bool
    
//    init(id: String, name: String, details: String, topics: [Topic], author: String, isPublic: Bool) {
    init(id: String, name: String, details: String, topics: [TopicPreload], author: String, isPublic: Bool) {
        self.id = id
        self.name = name
        self.details = details
        self.topics = topics
        self.author = author
        self.isPublic = isPublic
    }
    
//    init(name: String, details: String, topics: [Topic], author: String, isPublic: Bool) {
    init(name: String, details: String, topics: [TopicPreload], author: String, isPublic: Bool) {
        self.init(id: UUID().uuidString,
                  name: name,
                  details: details,
                  topics: topics,
                  author: author,
                  isPublic: isPublic)
    }
    
    init() {
        self.init(name: "", details: "", topics: [], author: "", isPublic: false)
    }
}

extension Module: Equatable {}

extension Module {
    var modulePreload: ModulePreload {
        let topicIds = topics.map { $0.id }
        return ModulePreload(id: id,
                             name: name,
                             author: author,
                             isPublic: isPublic)
    }
}
