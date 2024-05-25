//
//  ModulePreload.swift
//  LearnWords
//
//  Created by sergemi on 28.04.2024.
//

import Foundation

struct ModulePreload {
    let id: String
    
    var name: String
    var details: String
//    var topics: [Topic]
    var topicsIds: [String]
    
    var author: String // author id
    var isPublic: Bool
    
//    init(id: String, name: String, details: String, topics: [Topic], author: String, isPublic: Bool) {
    init(id: String, name: String, details: String, topicsIds: [String], author: String, isPublic: Bool) {
        self.id = id
        self.name = name
        self.details = details
        self.topicsIds = topicsIds
        self.author = author
        self.isPublic = isPublic
    }
    
//    init(name: String, details: String, topics: [Topic], author: String, isPublic: Bool) {
    init(name: String, details: String, topicsIds: [String], author: String, isPublic: Bool) {
        self.init(id: UUID().uuidString,
                  name: name,
                  details: details,
                  topicsIds: topicsIds,
                  author: author,
                  isPublic: isPublic)
    }
    
    init() {
        self.init(name: "", details: "", topicsIds: [], author: "", isPublic: false)
    }
}
