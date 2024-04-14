//
//  Topic.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

struct Topic {
    let id: String
    
    var name: String
    var details: String
    var words: [LearnedWord]
    var exercises: [Exercise]
    
    init(id: String, name: String, details: String, words: [LearnedWord], exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.details = details
        self.words = words
        self.exercises = exercises
    }
    
    init (name: String, details: String, words: [LearnedWord], exercises: [Exercise]) {
        self.init(id: UUID().uuidString,
                  name: name,
                  details: details,
                  words: words,
                  exercises: exercises)
    }
}
