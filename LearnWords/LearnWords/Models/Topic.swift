//
//  Topic.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

struct Topic: Equatable, Codable {
    let id: String
    
    var name: String
    var details: String
    var words: [LearnedWord]
    var exercises: [ExerciseType]
    
    init(id: String, name: String, details: String, words: [LearnedWord], exercises: [ExerciseType]) {
        self.id = id
        self.name = name
        self.details = details
        self.words = words
        self.exercises = exercises
    }
    
    init(name: String, details: String, words: [LearnedWord], exercises: [ExerciseType]) {
        self.init(id: UUID().uuidString,
                  name: name,
                  details: details,
                  words: words,
                  exercises: exercises)
    }
    
    init() {
        self.init(name: "", details: "", words: [], exercises: [])
    }
    
    // MARK - Codable
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case details
        case words
        case exercises
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(details, forKey: .details)
        try container.encode(words, forKey: .words)
        try container.encode(exercises, forKey: .exercises)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        details = try container.decode(String.self, forKey: .details)
        words = try container.decodeIfPresent([LearnedWord].self, forKey: .words) ?? []
        exercises = try container.decodeIfPresent([ExerciseType].self, forKey: .exercises) ?? []
    }
}


extension Topic {
    var topicPreload:TopicPreload {
        return TopicPreload(id: id,
                            name: name)
    }
}
