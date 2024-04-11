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
    
    init(name: String, details: String, words: [LearnedWord], exercises: [Exercise]) {
        self.id = UUID().uuidString
        self.name = name
        self.details = details
        self.words = words
        self.exercises = exercises
    }
}
