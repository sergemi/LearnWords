//
//  LearnedWord.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

struct LearnedWord {
    let id: String
    
    var word: WordPair
    var exercises: [Exercise]
    
    init (id: String, word: WordPair, exercises: [Exercise]) {
        self.id = id
        self.word = word
        self.exercises = exercises
    }
    
    init (word: WordPair, exercises: [Exercise]) {
        self.init(id: UUID().uuidString,
                  word: word,
                  exercises: exercises)
    }
}
