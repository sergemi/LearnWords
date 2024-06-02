//
//  Module.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

struct Module: Equatable, Codable {
    let id: String
    
    var name: String
    var details: String
    var topics: [TopicPreload]
    var author: String // author id
    var isPublic: Bool
    
    init(id: String, name: String, details: String, topics: [TopicPreload], author: String, isPublic: Bool) {
        self.id = id
        self.name = name
        self.details = details
        self.topics = topics
        self.author = author
        self.isPublic = isPublic
    }
    
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
    
    // MARK - Codable
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case details
        case topics
        case author
        case isPublic
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(details, forKey: .details)
        try container.encode(topics, forKey: .topics)
        try container.encode(author, forKey: .author)
        try container.encode(isPublic, forKey: .isPublic)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        details = try container.decode(String.self, forKey: .details)
        
        topics = try container.decodeIfPresent([TopicPreload].self, forKey: .topics) ?? []
        
        author = try container.decode(String.self, forKey: .author)
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
    }
    
}

extension Module {
    var modulePreload: ModulePreload {
        let topicIds = topics.map { $0.id }
        return ModulePreload(id: id,
                             name: name,
                             author: author,
                             isPublic: isPublic)
    }
}
