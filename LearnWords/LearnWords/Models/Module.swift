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
    var topics: [Topic]
    
    var author: String // author id
    var isPublic: Bool
    
    init(id: String, name: String, details: String, topics: [Topic], author: String, isPublic: Bool) {
        self.id = id
        self.name = name
        self.details = details
        self.topics = topics
        self.author = author
        self.isPublic = isPublic
    }
    
    init(name: String, details: String, topics: [Topic], author: String, isPublic: Bool) {
        self.init(id: UUID().uuidString,
                  name: name,
                  details: details,
                  topics: topics,
                  author: author,
                  isPublic: isPublic)
    }
}

extension Module: Equatable {}
